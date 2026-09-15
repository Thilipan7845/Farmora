# ============================================================
# FARMORA LIVE MARKET INCREMENTAL UPDATER
# Fetch → Filter → Insert
# ============================================================


from datetime import datetime


from fetch_market_data import fetch_market_data

from mapper import map_market_records

from supabase_writer import (
    get_latest_date,
    insert_market_records
)



# ============================================================
# CROPS
# ============================================================


CROPS = [

    "Cotton",

    "Rice",

    "Wheat",

    "Onion",

    "Tomato",

    "Sugarcane"

]


STATE = "Maharashtra"



# ============================================================
# DATE COMPARISON
# ============================================================


def is_new_record(
    record_date,
    latest_date
):


    if not latest_date:

        return True



    return record_date > latest_date



# ============================================================
# UPDATE ONE CROP
# ============================================================


def update_crop(crop):


    print("\n")
    print("=" * 60)

    print(
        "Updating:",
        crop
    )

    print("=" * 60)



    # Get existing latest date

    latest_date = get_latest_date(
        crop
    )


    print(
        "Latest stored date:",
        latest_date
    )



    # Fetch API data

    records = fetch_market_data(

        crop=crop,

        state=STATE,

        limit=500

    )



    print(
        "API records:",
        len(records)
    )



    if not records:

        return



    # Convert API format

    mapped_records = map_market_records(
        records
    )



    new_records = []



    for record in mapped_records:


        if is_new_record(

            record["price_date"],

            latest_date

        ):

            new_records.append(
                record
            )



    print(
        "New records:",
        len(new_records)
    )



    if new_records:


        insert_market_records(
            new_records
        )


        print(
            "Inserted successfully"
        )


    else:


        print(
            "Already up to date"
        )



# ============================================================
# UPDATE ALL CROPS
# ============================================================


def update_all_market_data():


    print(
        "\nFARMORA INCREMENTAL UPDATE"
    )


    for crop in CROPS:


        try:


            update_crop(
                crop
            )


        except Exception as e:


            print(
                crop,
                "failed:",
                e
            )



    print(
        "\nUPDATE COMPLETE"
    )



# ============================================================
# RUN
# ============================================================


if __name__ == "__main__":


    update_all_market_data()