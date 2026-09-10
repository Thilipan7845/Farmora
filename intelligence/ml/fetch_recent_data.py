import os
import time
from pathlib import Path

import requests
import pandas as pd
from dotenv import load_dotenv


# ============================================================
# FARMORA - FETCH RECENT MARKET DATA
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent

load_dotenv(BASE_DIR / ".env")

API_KEY = os.getenv("DATA_GOV_API_KEY")

API_URL = (
    "https://api.data.gov.in/resource/"
    "35985678-0d79-46b4-9ed6-6f13308a1d24"
)

STATE = "Maharashtra"

# Number of recent records we want per crop
RECENT_RECORDS = 5000

PAGE_SIZE = 100

TIMEOUT = (15, 180)

MAX_RETRIES = 3

RETRY_DELAY = 5


# Only crops that actually have data
CROPS = [
    "Cotton",
    "Rice",
    "Sugarcane",
    "Wheat",
    "Onion",
    "Tomato",
]


# Save recent data separately first
OUTPUT_DIR = (
    BASE_DIR
    / "data"
    / "raw"
    / "recent"
)

OUTPUT_DIR.mkdir(
    parents=True,
    exist_ok=True
)


# ============================================================
# CHECK API KEY
# ============================================================

if not API_KEY:
    raise RuntimeError(
        "DATA_GOV_API_KEY was not found in .env"
    )


# ============================================================
# API REQUEST
# ============================================================

def make_request(params):

    headers = {
        "Accept": "application/json",
        "User-Agent": "Mozilla/5.0",
    }

    for attempt in range(1, MAX_RETRIES + 1):

        try:

            print(
                f"    Request "
                f"{attempt}/{MAX_RETRIES}"
            )

            response = requests.get(
                API_URL,
                params=params,
                headers=headers,
                timeout=TIMEOUT,
            )

            print(
                f"    Status: "
                f"{response.status_code}"
            )

            if response.status_code == 200:

                data = response.json()

                if data.get("status") == "error":

                    print(
                        "    API error:",
                        data.get("message")
                    )

                    return None

                return data

            if response.status_code in [
                429,
                500,
                502,
                503,
                504,
            ]:

                print(
                    "    Temporary API error."
                )

                if attempt < MAX_RETRIES:

                    time.sleep(RETRY_DELAY)

                    continue

                return None

            if response.status_code in [
                401,
                403,
            ]:

                print(
                    "    API key authorization failed."
                )

                return None

            print(
                response.text[:1000]
            )

            return None

        except requests.exceptions.Timeout:

            print(
                "    Request timed out."
            )

            if attempt < MAX_RETRIES:

                time.sleep(RETRY_DELAY)

            else:

                return None

        except requests.exceptions.ConnectionError as e:

            print(
                "    Connection error:"
            )

            print(e)

            if attempt < MAX_RETRIES:

                time.sleep(RETRY_DELAY)

            else:

                return None

        except Exception as e:

            print(
                "    Unexpected error:"
            )

            print(e)

            return None

    return None


# ============================================================
# GET TOTAL NUMBER OF RECORDS
# ============================================================

def get_total_records(crop):

    print(
        f"\n    Checking total records for {crop}..."
    )

    params = {
        "api-key": API_KEY,
        "format": "json",
        "limit": 1,
        "offset": 0,
        "filters[State]": STATE,
        "filters[Commodity]": crop,
    }

    data = make_request(params)

    if data is None:
        return None

    total = data.get("total", 0)

    try:
        total = int(total)
    except:
        total = 0

    print(
        f"    Total available: {total}"
    )

    return total


# ============================================================
# FETCH RECENT RECORDS
# ============================================================

def fetch_recent_crop(crop):

    print("\n" + "=" * 65)
    print(f"RECENT DATA: {crop.upper()}")
    print("=" * 65)

    total = get_total_records(crop)

    if total is None:
        return []

    if total == 0:

        print(
            "    No records found."
        )

        return []

    # Start near the end of the dataset
    start_offset = max(
        total - RECENT_RECORDS,
        0
    )

    records_needed = min(
        RECENT_RECORDS,
        total
    )

    print(
        f"    Starting offset: {start_offset}"
    )

    print(
        f"    Records requested: {records_needed}"
    )

    all_records = []

    offset = start_offset

    while len(all_records) < records_needed:

        remaining = (
            records_needed
            - len(all_records)
        )

        current_limit = min(
            PAGE_SIZE,
            remaining
        )

        params = {
            "api-key": API_KEY,
            "format": "json",
            "limit": current_limit,
            "offset": offset,
            "filters[State]": STATE,
            "filters[Commodity]": crop,
        }

        print(
            f"    Fetching offset "
            f"{offset}..."
        )

        data = make_request(params)

        if data is None:

            print(
                f"    Failed while fetching {crop}."
            )

            break

        records = data.get(
            "records",
            []
        )

        if not records:

            print(
                "    No more records."
            )

            break

        all_records.extend(records)

        print(
            f"    Received: {len(records)}"
        )

        print(
            f"    Collected: {len(all_records)}"
        )

        if len(records) < current_limit:

            break

        offset += current_limit

        time.sleep(1)

    return all_records


# ============================================================
# CLEAN + SAVE
# ============================================================

def save_recent_data(crop, records):

    if not records:

        print(
            f"    Nothing to save for {crop}."
        )

        return

    df = pd.DataFrame(records)

    # Clean column names
    df.columns = [
        str(c).strip()
        for c in df.columns
    ]

    # Convert prices
    for column in [
        "Min_Price",
        "Max_Price",
        "Modal_Price",
    ]:

        if column in df.columns:

            df[column] = pd.to_numeric(
                df[column],
                errors="coerce"
            )

    # Convert date
    if "Arrival_Date" in df.columns:

        df["Arrival_Date"] = pd.to_datetime(
            df["Arrival_Date"],
            dayfirst=True,
            errors="coerce"
        )

    # Remove duplicates
    df = df.drop_duplicates()

    # Sort newest first
    if "Arrival_Date" in df.columns:

        df = df.sort_values(
            "Arrival_Date"
        )

    filename = (
        crop.lower()
        .replace(" ", "_")
    )

    output_file = (
        OUTPUT_DIR
        / f"{filename}_recent.csv"
    )

    df.to_csv(
        output_file,
        index=False
    )

    print(
        f"\n    SAVED:"
    )

    print(
        f"    {output_file}"
    )

    print(
        f"    Rows: {len(df)}"
    )

    if "Arrival_Date" in df.columns:

        valid_dates = df[
            "Arrival_Date"
        ].dropna()

        if len(valid_dates) > 0:

            print(
                f"    From: "
                f"{valid_dates.min().date()}"
            )

            print(
                f"    To:   "
                f"{valid_dates.max().date()}"
            )


# ============================================================
# MAIN
# ============================================================

def main():

    print("\n")
    print("=" * 65)
    print("FARMORA - RECENT MARKET DATA")
    print("=" * 65)

    print(
        f"State: {STATE}"
    )

    print(
        f"Crops: {len(CROPS)}"
    )

    print(
        f"Recent records/crop: "
        f"{RECENT_RECORDS}"
    )

    print(
        f"Output: {OUTPUT_DIR}"
    )

    print("=" * 65)

    successful = 0

    for crop in CROPS:

        records = fetch_recent_crop(
            crop
        )

        if records:

            save_recent_data(
                crop,
                records
            )

            successful += 1

        time.sleep(2)

    print("\n")
    print("=" * 65)
    print("RECENT DATA DOWNLOAD COMPLETE")
    print("=" * 65)

    print(
        f"Successful crops: "
        f"{successful}/{len(CROPS)}"
    )

    print(
        f"Files are in:"
    )

    print(
        OUTPUT_DIR
    )

    print("=" * 65)


if __name__ == "__main__":
    main()