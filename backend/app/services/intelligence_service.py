import sys
from pathlib import Path

# Add the Farmora project root to Python's import path
PROJECT_ROOT = Path(__file__).resolve().parents[3]

if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))


from intelligence.ml.farmora_predict import predict_market_decision

from app.schemas.intelligence import IntelligenceDecisionRequest
from app.services.market_feature_service import build_market_features


def get_market_decision(request: IntelligenceDecisionRequest):

    # ------------------------------------------------------------
    # BUILD FEATURES FROM SUPABASE MARKET HISTORY
    # ------------------------------------------------------------

    market_data = build_market_features(
        crop=request.crop,
        market=request.market,
        variety=request.variety,
        grade=request.grade,
    )

    # ------------------------------------------------------------
    # CHECK WHETHER ENOUGH HISTORY EXISTS
    # ------------------------------------------------------------

    if not market_data["prediction_ready"]:
        return {
            "status": "insufficient_market_history",
            "message": (
                "Not enough historical market data is available "
                "to generate a reliable ML prediction."
            ),
            "crop": request.crop,
            "market": request.market,
            "variety": request.variety,
            "grade": request.grade,
            "record_count": market_data["record_count"],
            "minimum_required_records": 31,
            "latest_price_date": market_data["latest_price_date"],
            "current_price": market_data["features"]["Modal_Price"],
        }

    # ------------------------------------------------------------
    # RUN INTELLIGENCE MODEL
    # ------------------------------------------------------------

    result = predict_market_decision(
        crop=request.crop,
        input_data=market_data["features"],
        storage_available=request.storage_available,
        storage_cost=request.storage_cost,
        demand_level=request.demand_level,
        quantity=request.quantity,
        transport_cost=request.transport_cost,
        storage_expense=request.storage_expense,
    )

    return result