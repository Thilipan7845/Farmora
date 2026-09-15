# ============================================================
# Farmora Market Data Mapper
# Converts API response into Supabase market_prices format
# ============================================================


from datetime import datetime



# ============================================================
# SAFE CONVERSION FUNCTIONS
# ============================================================


def safe_float(value):

    try:
        return float(value)

    except:

        return 0.0



def convert_date(date_string):

    """
    Converts:
        DD/MM/YYYY

    To:
        YYYY-MM-DD
    """

    if not date_string:
        return None


    try:

        return datetime.strptime(
            date_string,
            "%d/%m/%Y"
        ).strftime(
            "%Y-%m-%d"
        )


    except:

        return None



# ============================================================
# SINGLE RECORD MAPPER
# ============================================================


def map_market_record(record):


    return {


        "crop_name":

            record.get(
                "Commodity",
                ""
            ),



        "market_name":

            record.get(
                "Market",
                ""
            ),



        "district":

            record.get(
                "District",
                ""
            ),



        "state":

            record.get(
                "State",
                ""
            ),



        "min_price":

            safe_float(
                record.get(
                    "Min_Price"
                )
            ),



        "max_price":

            safe_float(
                record.get(
                    "Max_Price"
                )
            ),



        "modal_price":

            safe_float(
                record.get(
                    "Modal_Price"
                )
            ),



        "price_date":

            convert_date(
                record.get(
                    "Arrival_Date"
                )
            ),



        "variety":

            record.get(
                "Variety",
                ""
            ),



        "grade":

            record.get(
                "Grade",
                ""
            )

    }



# ============================================================
# MULTIPLE RECORD MAPPER
# ============================================================


def map_market_records(records):


    mapped = []


    for record in records:


        mapped.append(

            map_market_record(
                record
            )

        )


    return mapped