import sys
from pathlib import Path


# Add Farmora project root to Python path
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



def get_market_history(
    crop: str,
    market: str,
    variety: str | None = None,
    grade: str | None = None,
):

    """
    Fetch raw market history from Supabase.

    Intelligence team expects:

    [
        {
            Arrival_Date,
            Min_Price,
            Max_Price,
            Modal_Price
        }
    ]

    """

    result = (
        supabase
        .table("market_prices")
        .select("*")
        .eq("crop_name", crop)
        .eq("market_name", market)
        .order("price_date", desc=False)
        .execute()
    )


    rows = result.data


    if not rows:
        raise ValueError(
            "No market history available."
        )


    history = []


    for row in rows:


        if variety is not None:

            if row.get("variety") != variety:
                continue


        if grade is not None:

            if row.get("grade") != grade:
                continue



        history.append(
            {
                "Arrival_Date": row["price_date"],

                "Min_Price": float(
                    row["min_price"]
                ),

                "Max_Price": float(
                    row["max_price"]
                ),

                "Modal_Price": float(
                    row["modal_price"]
                )
            }
        )


    if len(history) == 0:

        raise ValueError(
            "No matching market history found."
        )


    return history





def get_market_decision(
    request: IntelligenceDecisionRequest
):


    # --------------------------------------------------
    # GET RAW MARKET HISTORY
    # --------------------------------------------------

    history = get_market_history(

        crop=request.crop,

        market=request.market,

        variety=request.variety,

        grade=request.grade

    )



    # --------------------------------------------------
    # CHECK HISTORY
    # Intelligence requires minimum 30 records
    # --------------------------------------------------

    if len(history) < 30:


        return {

            "status":
            "insufficient_market_history",


            "message":
            (
                "Minimum 30 historical "
                "market records required."
            ),


            "crop":
            request.crop,


            "market":
            request.market,


            "record_count":
            len(history),


            "minimum_required_records":
            30

        }



    # --------------------------------------------------
    # CALL INTELLIGENCE V1
    # --------------------------------------------------

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
