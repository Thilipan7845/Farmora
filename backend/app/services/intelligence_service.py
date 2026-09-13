import sys
from pathlib import Path


# ============================================================
# Add Farmora root
# ============================================================

PROJECT_ROOT = Path(__file__).resolve().parents[3]

if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))


from intelligence.ml.farmora_predict import (
    predict_from_market_history
)

from app.schemas.intelligence import (
    IntelligenceDecisionRequest
)

from app.database.supabase_client import supabase



# ============================================================
# Fetch Market History
# ============================================================

def get_market_history(
    crop: str,
    market: str,
    variety: str | None = None,
    grade: str | None = None,
):


    # --------------------------------------------------------
    # Normalize only for comparison
    # --------------------------------------------------------

    crop_search = crop.strip().lower()

    market_search = market.strip().lower()


    variety_search = (
        variety.strip().lower()
        if variety
        else None
    )


    grade_search = (
        grade.strip().lower()
        if grade
        else None
    )


    # --------------------------------------------------------
    # Fetch all rows
    # --------------------------------------------------------

    result = (
        supabase
        .table("market_prices")
        .select("*")
        .execute()
    )


    rows = result.data


    print("\n==============================")
    print("MARKET SEARCH")
    print("==============================")

    print("Crop:", crop_search)
    print("Market:", market_search)
    print("Variety:", variety_search)
    print("Grade:", grade_search)

    print("Total DB rows:", len(rows))


    # --------------------------------------------------------
    # Filter manually (case insensitive)
    # --------------------------------------------------------

    filtered_rows = []


    for row in rows:


        if (
            row["crop_name"]
            .strip()
            .lower()
            != crop_search
        ):
            continue


        if (
            row["market_name"]
            .strip()
            .lower()
            != market_search
        ):
            continue



        if variety_search:

            if (
                row.get("variety","")
                .strip()
                .lower()
                != variety_search
            ):
                continue



        if grade_search:

            if (
                row.get("grade","")
                .strip()
                .lower()
                != grade_search
            ):
                continue



        filtered_rows.append(row)



    print(
        "Matching rows:",
        len(filtered_rows)
    )

    print("==============================\n")



    if not filtered_rows:

        raise ValueError(
            "No market history available."
        )



    # --------------------------------------------------------
    # Convert to Intelligence format
    # --------------------------------------------------------

    history = []


    for row in filtered_rows:


        history.append(

            {

                "Arrival_Date":
                    row["price_date"],


                "Min_Price":
                    float(row["min_price"]),


                "Max_Price":
                    float(row["max_price"]),


                "Modal_Price":
                    float(row["modal_price"])

            }

        )


    return history





# ============================================================
# Main Decision Function
# ============================================================

def get_market_decision(
    request: IntelligenceDecisionRequest
):


    history = get_market_history(

        crop=request.crop,

        market=request.market,

        variety=request.variety,

        grade=request.grade

    )



    if len(history) < 30:


        return {


            "status":
            "insufficient_market_history",


            "message":
            "Minimum 30 historical market records required.",


            "crop":
            request.crop,


            "market":
            request.market,


            "record_count":
            len(history),


            "minimum_required_records":
            30

        }



    result = predict_from_market_history(

        crop=request.crop,

        market=request.market,

        variety=request.variety,

        grade=request.grade,

        history=history,


        storage_available=
        request.storage_available,


        storage_cost=
        request.storage_cost,


        demand_level=
        request.demand_level,


        quantity=
        request.quantity,


        transport_cost=
        request.transport_cost,


        storage_expense=
        request.storage_expense

    )


    return result