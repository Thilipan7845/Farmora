import os
import time
from pathlib import Path

import requests
import pandas as pd
from dotenv import load_dotenv


# ============================================================
# FARMORA - CONTINUE MARKET DATA DOWNLOAD
# ============================================================

# Project folder
BASE_DIR = Path(__file__).resolve().parent.parent

# Load .env
load_dotenv(BASE_DIR / ".env")

API_KEY = os.getenv("DATA_GOV_API_KEY")


# ============================================================
# API CONFIGURATION
# ============================================================

API_URL = (
    "https://api.data.gov.in/resource/"
    "35985678-0d79-46b4-9ed6-6f13308a1d24"
)

STATE = "Maharashtra"

PAGE_SIZE = 100

MAX_RECORDS_PER_CROP = 5000

REQUEST_TIMEOUT = (15, 180)

MAX_RETRIES = 3

RETRY_DELAY = 5


# ============================================================
# ONLY THE REMAINING CROPS
# ============================================================

CROPS = [
    "Onion",
    "Tomato",
    "Pigeon Pea",
    "Pearl Millet",
]


# ============================================================
# RAW DATA FOLDER
# ============================================================

RAW_DIR = BASE_DIR / "data" / "raw"

RAW_DIR.mkdir(parents=True, exist_ok=True)


# ============================================================
# CHECK API KEY
# ============================================================

if not API_KEY:
    raise RuntimeError(
        "DATA_GOV_API_KEY was not found.\n"
        "Please check your .env file."
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
                f"    Request attempt "
                f"{attempt}/{MAX_RETRIES}..."
            )

            response = requests.get(
                API_URL,
                params=params,
                headers=headers,
                timeout=REQUEST_TIMEOUT,
            )

            print(
                f"    HTTP status: "
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

            if response.status_code in [429, 500, 502, 503, 504]:

                print(
                    f"    Temporary server error: "
                    f"{response.status_code}"
                )

                if attempt < MAX_RETRIES:

                    time.sleep(RETRY_DELAY)

                    continue

                return None

            if response.status_code in [401, 403]:

                print(
                    "    API authentication failed."
                )

                return None

            print(
                "    API request failed:"
            )

            print(
                response.text[:1000]
            )

            return None

        except requests.exceptions.Timeout:

            print(
                "    Request timed out."
            )

            if attempt < MAX_RETRIES:

                print(
                    f"    Waiting {RETRY_DELAY} seconds..."
                )

                time.sleep(RETRY_DELAY)

            else:

                print(
                    "    Maximum retries reached."
                )

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
# FETCH ONE CROP
# ============================================================

def fetch_crop_data(crop):

    print("\n" + "=" * 60)
    print(f"Fetching: {crop}")
    print("=" * 60)

    all_records = []

    offset = 0

    while len(all_records) < MAX_RECORDS_PER_CROP:

        remaining = (
            MAX_RECORDS_PER_CROP
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
            f"    Fetching records "
            f"{offset} to "
            f"{offset + current_limit - 1}"
        )

        data = make_request(params)

        if data is None:

            print(
                f"    Failed to fetch {crop}."
            )

            break

        records = data.get("records", [])

        if not records:

            print(
                "    No more records."
            )

            break

        all_records.extend(records)

        print(
            f"    Received {len(records)} records."
        )

        print(
            f"    Total collected: "
            f"{len(all_records)}"
        )

        if len(records) < current_limit:

            print(
                "    Reached end of available data."
            )

            break

        offset += current_limit

        time.sleep(1)

    return all_records


# ============================================================
# SAVE DATA
# ============================================================

def save_crop_data(crop, records):

    if not records:

        print(
            f"    Nothing to save for {crop}."
        )

        return None

    df = pd.DataFrame(records)

    # Clean column names
    df.columns = [
        str(column).strip()
        for column in df.columns
    ]

    # Convert prices to numbers
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

    # Remove empty rows
    df = df.dropna(
        how="all"
    )

    # Remove duplicates
    df = df.drop_duplicates()

    # Sort by date
    if "Arrival_Date" in df.columns:

        df = df.sort_values(
            "Arrival_Date"
        )

    # Filename
    filename = (
        crop.lower()
        .replace(" ", "_")
        .replace("/", "_")
    )

    output_file = (
        RAW_DIR
        / f"{filename}_maharashtra.csv"
    )

    df.to_csv(
        output_file,
        index=False
    )

    print(
        f"\n    SAVED: {output_file}"
    )

    print(
        f"    Rows: {len(df)}"
    )

    return df


# ============================================================
# MAIN
# ============================================================

def main():

    print("\n")
    print("=" * 60)
    print("FARMORA - CONTINUING DATA DOWNLOAD")
    print("=" * 60)

    print(
        "Already downloaded:"
    )

    print(
        "  ✓ Cotton"
    )

    print(
        "  ✓ Rice"
    )

    print(
        "  ✓ Sugarcane"
    )

    print(
        "  ✓ Wheat"
    )

    print("\nRemaining crops:")

    for crop in CROPS:

        print(
            f"  → {crop}"
        )

    print("=" * 60)

    successful = 0
    failed = 0
    total_records = 0

    for crop in CROPS:

        records = fetch_crop_data(crop)

        if records:

            df = save_crop_data(
                crop,
                records
            )

            if df is not None:

                successful += 1

                total_records += len(df)

        else:

            failed += 1

        time.sleep(2)

    print("\n")
    print("=" * 60)
    print("DOWNLOAD COMPLETE")
    print("=" * 60)

    print(
        f"Successful: {successful}"
    )

    print(
        f"Failed: {failed}"
    )

    print(
        f"New records saved: {total_records}"
    )

    print(
        f"Location: {RAW_DIR}"
    )

    print("=" * 60)


# ============================================================
# RUN
# ============================================================

if __name__ == "__main__":
    main()