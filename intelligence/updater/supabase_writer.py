# ============================================================
# FARMORA SUPABASE MARKET DATA WRITER
# ============================================================


import os

from dotenv import load_dotenv

from supabase import create_client



# ============================================================
# ENV
# ============================================================


load_dotenv()



SUPABASE_URL = os.getenv(
    "SUPABASE_URL"
)


SUPABASE_KEY = os.getenv(
    "SUPABASE_KEY"
)



if not SUPABASE_URL or not SUPABASE_KEY:

    raise Exception(
        "Supabase credentials missing"
    )



# ============================================================
# CLIENT
# ============================================================


supabase = create_client(

    SUPABASE_URL,

    SUPABASE_KEY

)



# ============================================================
# GET LAST STORED DATE
# ============================================================


def get_latest_date(crop):


    response = (

        supabase

        .table(
            "market_prices"
        )

        .select(
            "price_date"
        )

        .eq(
            "crop_name",
            crop
        )

        .order(
            "price_date",
            desc=True
        )

        .limit(
            1
        )

        .execute()

    )


    if response.data:


        return response.data[0][
            "price_date"
        ]


    return None



# ============================================================
# INSERT NEW RECORDS
# ============================================================


def insert_market_records(records):


    if not records:


        print(
            "No new records"
        )


        return None



    response = (

        supabase

        .table(
            "market_prices"
        )

        .insert(
            records
        )

        .execute()

    )


    return response