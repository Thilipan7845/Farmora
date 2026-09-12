from pathlib import Path
import sys


# ============================================================
# PYTHON PATH
# ============================================================

BACKEND_DIR = Path(__file__).resolve().parents[1]
PROJECT_ROOT = BACKEND_DIR.parent

if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))


# ============================================================
# IMPORTS
# ============================================================

from app.services.market_feature_service import (
    build_market_features,
)

from intelligence.ml.farmora_predict import (
    predict_market_decision,
)


# ============================================================
# BUILD REAL MARKET FEATURES
# ============================================================

market_data = build_market_features(
    crop="Cotton",
    market="Parbhani",
    variety="Other",
    grade="FAQ",
)


print("=" * 70)
print("LIVE MARKET → ML PREDICTION TEST")
print("=" * 70)

print(
    f"\nHistorical records: "
    f"{market_data['record_count']}"
)

print(
    f"Latest price date: "
    f"{market_data['latest_price_date']}"
)

print(
    f"Prediction ready: "
    f"{market_data['prediction_ready']}"
)


# ============================================================
# SAFETY CHECK
# ============================================================

if not market_data["prediction_ready"]:

    print(
        "\nPrediction cannot be generated because "
        "historical data is insufficient."
    )

    raise SystemExit(0)


# ============================================================
# RUN FARMORA INTELLIGENCE
# ============================================================

result = predict_market_decision(
    crop="Cotton",
    input_data=market_data["features"],
    storage_available=True,
    storage_cost="LOW",
    demand_level="HIGH",
    quantity=2000,
    transport_cost=10000,
    storage_expense=5000,
)


# ============================================================
# DISPLAY RESULT
# ============================================================

print("\n" + "=" * 70)
print("INTELLIGENCE RESULT")
print("=" * 70)

print("\nCrop:")
print(result["crop"])

print("\nCurrent price:")
print(result["current_price"])

print("\nPredicted price:")
print(result["predicted_price"])

print("\nExpected change:")
print(
    result["expected_change_percent"],
    "%",
)

print("\nPrediction horizon:")
print(
    result["prediction_horizon_days"],
    "days",
)

print("\nConfidence:")
print(
    result["confidence_score"],
    "%",
)

print("\nExpected price range:")
print(
    result["expected_price_range"]
)

print("\nTrend:")
print(result["trend"])

print("\nRecommendation:")
print(result["recommendation"])

print("\nReasons:")
for reason in result["reasons"]:
    print("-", reason)

print("\nQuantity strategy:")
print(result["quantity_strategy"])

print("\nProfit analysis:")
print(result["profit_analysis"])

print("\nCrop profile:")
print(result["crop_profile"])

print("\nFarmer explanation:")
print(result["farmer_explanation"])

print("\n" + "=" * 70)
print("LIVE ML PREDICTION TEST COMPLETE")
print("=" * 70)