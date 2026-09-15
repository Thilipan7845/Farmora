from supabase_writer import insert_market_records



sample = [

    {

        "crop_name": "Cotton",

        "market_name": "Akot",

        "district": "Akola",

        "state": "Maharashtra",

        "min_price": 2325,

        "max_price": 2325,

        "modal_price": 2325,

        "price_date": "2026-09-15",

        "variety": "DCH-32",

        "grade": "FAQ"

    }

]



result = insert_market_records(
    sample
)



print(result)