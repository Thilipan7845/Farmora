# ============================================================
# FARMORA - LIVE MARKET DATA FETCHER
# Fetches latest mandi prices from data.gov.in
# ============================================================


import os
import time
import requests

from pathlib import Path
from dotenv import load_dotenv



# ============================================================
# PATH + ENV
# ============================================================


BASE_DIR = Path(__file__).resolve().parent.parent


load_dotenv(
    BASE_DIR / ".env"
)


API_KEY = os.getenv(
    "DATA_GOV_API_KEY"
)



API_URL = (
    "https://api.data.gov.in/resource/"
    "35985678-0d79-46b4-9ed6-6f13308a1d24"
)



REQUEST_TIMEOUT = (
    15,
    180
)


MAX_RETRIES = 3


RETRY_DELAY = 5



# ============================================================
# REQUEST HANDLER
# ============================================================


def make_request(params):


    headers = {

        "Accept": "application/json",

        "User-Agent":
            "Farmora-Live-Updater"

    }


    for attempt in range(
        1,
        MAX_RETRIES + 1
    ):


        try:

            print(
                f"API attempt {attempt}/{MAX_RETRIES}"
            )


            response = requests.get(

                API_URL,

                params=params,

                headers=headers,

                timeout=REQUEST_TIMEOUT

            )


            print(
                "HTTP:",
                response.status_code
            )


            response.raise_for_status()


            data = response.json()


            if "records" not in data:

                print(
                    "No records received"
                )

                return []


            return data["records"]



        except Exception as e:


            print(
                "API error:",
                e
            )


            if attempt < MAX_RETRIES:

                time.sleep(
                    RETRY_DELAY
                )



    return []



# ============================================================
# FETCH MARKET DATA
# ============================================================


def fetch_market_data(

    crop=None,

    state=None,

    limit=50

):


    params = {


        "api-key":

            API_KEY,


        "format":

            "json",


        "limit":

            limit,


        # latest records first

        "sort":

            "Arrival_Date",


        "order":

            "desc"

    }



    if crop:


        params[
            "filters[Commodity]"
        ] = crop



    if state:


        params[
            "filters[State]"
        ] = state



    records = make_request(
        params
    )


    return records



# ============================================================
# TEST
# ============================================================


if __name__ == "__main__":


    records = fetch_market_data(

        crop="Cotton",

        state="Maharashtra",

        limit=5

    )


    print(
        "\nRecords:",
        len(records)
    )


    for record in records:

        print(record)