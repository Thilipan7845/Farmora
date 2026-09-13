from datetime import date, timedelta

import sys
from pathlib import Path

# Add backend root folder to Python path
sys.path.append(
    str(Path(__file__).resolve().parent.parent)
)

from app.database.supabase_client import supabase


def seed_market_prices():

    crops = [

        {
            "crop_name": "cotton",
            "market_name": "Nagpur",
            "district": "Nagpur",
            "state": "Maharashtra",
            "variety": "BT Cotton",
            "grade": "A",
            "base_price": 8200
        },

        {
            "crop_name": "rice",
            "market_name": "Pune",
            "district": "Pune",
            "state": "Maharashtra",
            "variety": "Other",
            "grade": "FAQ",
            "base_price": 4200
        },

        {
            "crop_name": "tomato",
            "market_name": "Kolhapur",
            "district": "Kolhapur",
            "state": "Maharashtra",
            "variety": "Other",
            "grade": "FAQ",
            "base_price": 2500
        },

        {
            "crop_name": "onion",
            "market_name": "Nagpur",
            "district": "Nagpur",
            "state": "Maharashtra",
            "variety": "Other",
            "grade": "FAQ",
            "base_price": 3000
        },

        {
            "crop_name": "wheat",
            "market_name": "Akola",
            "district": "Akola",
            "state": "Maharashtra",
            "variety": "Other",
            "grade": "FAQ",
            "base_price": 2800
        },

        {
            "crop_name": "sugarcane",
            "market_name": "Ulhasnagar",
            "district": "Ulhasnagar",
            "state": "Maharashtra",
            "variety": "Other",
            "grade": "FAQ",
            "base_price": 3500
        }

    ]


    start_date = date(2026, 8, 1)

    records = []


    for crop in crops:

        for i in range(31):

            current_date = start_date + timedelta(days=i)

            modal_price = crop["base_price"] + (i * 15)


            records.append(

                {
                    "crop_name": crop["crop_name"],

                    "market_name": crop["market_name"],

                    "district": crop["district"],

                    "state": crop["state"],


                    "variety": crop["variety"],

                    "grade": crop["grade"],


                    "min_price": modal_price - 200,

                    "max_price": modal_price + 300,

                    "modal_price": modal_price,


                    "price_date": current_date.isoformat()
                }

            )


    result = (

        supabase

        .table("market_prices")

        .insert(records)

        .execute()

    )


    if result.data:

        print(
            f"Inserted {len(result.data)} market price records"
        )

    else:

        print(
            "Failed to insert market price data"
        )



if __name__ == "__main__":

    seed_market_prices()