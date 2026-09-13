from datetime import date, timedelta

import sys
from pathlib import Path

# Add backend root folder to Python path
sys.path.append(
    str(Path(__file__).resolve().parent.parent)
)

from app.database.supabase_client import supabase


def seed_market_prices():

    crop_name = "cotton"
    market_name = "Nagpur"

    district = "Nagpur"
    state = "Maharashtra"

    variety = "BT Cotton"
    grade = "A"

    start_date = date(2026, 8, 1)

    records = []

    base_price = 8200

    for i in range(31):

        current_date = start_date + timedelta(days=i)

        # simulate realistic price movement
        modal_price = base_price + (i * 15)

        records.append(
            {
                "crop_name": crop_name,
                "market_name": market_name,
                "district": district,
                "state": state,

                "variety": variety,
                "grade": grade,

                "min_price": modal_price - 200,
                "max_price": modal_price + 300,
                "modal_price": modal_price,

                "price_date": current_date.isoformat(),
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