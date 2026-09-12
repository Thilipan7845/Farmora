import os
import json
import joblib
import pandas as pd
from pathlib import Path

from intelligence.ml.decision_engine import decide_sale
from intelligence.ml.profit_engine import calculate_profit
from intelligence.ml.explanation_engine import generate_farmer_explanation
from intelligence.ml.feature_builder import build_features


# ============================================================
# Intelligence Project Paths
# ============================================================

# farmora_predict.py:
# F:\Farmora\intelligence\ml\farmora_predict.py
#
# parents[0] -> F:\Farmora\intelligence\ml
# parents[1] -> F:\Farmora\intelligence
#
# Therefore the models directory is:
# F:\Farmora\intelligence\models

INTELLIGENCE_ROOT = Path(__file__).resolve().parents[1]

MODEL_DIR = INTELLIGENCE_ROOT / "models"


# ============================================================
# Crop prediction horizons
# ============================================================

HORIZONS = {
    "cotton": 14,
    "rice": 14,
    "sugarcane": 2,
    "wheat": 14,
    "onion": 5,
    "tomato": 3
}


# ============================================================
# Model Features
# ============================================================

FEATURES = [

    "Modal_Price",
    "Min_Price",
    "Max_Price",
    "Price_Range",
    "Modal_Position",

    "Year",
    "Month",
    "Week_Of_Year",
    "Day_Of_Week",
    "Quarter",

    "Lag_1",
    "Lag_2",
    "Lag_3",
    "Lag_5",
    "Lag_7",
    "Lag_14",
    "Lag_30",

    "Rolling_Mean_3",
    "Rolling_Mean_7",
    "Rolling_Mean_14",
    "Rolling_Mean_30",

    "Rolling_Std_7",
    "Rolling_Std_14",

    "Price_Change_1",
    "Price_Change_3",
    "Price_Change_7",
    "Price_Change_14",

    "Price_Change_Pct_1",
    "Price_Change_Pct_7",
    "Price_Change_Pct_14",

    "Market",
    "Variety",
    "Grade"

]


# ============================================================
# Load Crop Model
# ============================================================

def load_price_model(crop):

    crop = crop.lower().strip()

    model_path = MODEL_DIR / f"{crop}_price_model.joblib"

    if not model_path.exists():

        raise Exception(
            f"Model not found for {crop}. "
            f"Expected model at: {model_path}"
        )

    return joblib.load(model_path)


# ============================================================
# Load Model Metrics
# ============================================================

def load_model_metrics(crop):

    crop = crop.lower().strip()

    metrics_path = MODEL_DIR / f"{crop}_metrics.json"

    if not metrics_path.exists():

        raise Exception(
            f"Metrics not found for {crop}. "
            f"Expected metrics at: {metrics_path}"
        )

    with open(
        metrics_path,
        "r",
        encoding="utf-8"
    ) as file:

        return json.load(file)


# ============================================================
# MAIN INTELLIGENCE FUNCTION
# ============================================================

def predict_market_decision(

    crop,

    input_data,

    storage_available,

    storage_cost,

    demand_level,

    quantity,

    transport_cost,

    storage_expense

):

    crop = crop.lower().strip()

    # --------------------------------------------------------
    # Validate crop
    # --------------------------------------------------------

    if crop not in HORIZONS:

        raise Exception(
            f"Unsupported crop: {crop}"
        )

    # --------------------------------------------------------
    # Load model
    # --------------------------------------------------------

    model = load_price_model(crop)

    # --------------------------------------------------------
    # Prepare ML input
    # --------------------------------------------------------

    df = pd.DataFrame(
        [input_data]
    )

    # Ensure all expected features exist
    missing_features = [
        feature
        for feature in FEATURES
        if feature not in df.columns
    ]

    if missing_features:

        raise Exception(
            "Missing ML features: "
            + ", ".join(missing_features)
        )

    # Keep features in the exact trained-model order
    df = df[FEATURES]

    # --------------------------------------------------------
    # Predict price
    # --------------------------------------------------------

    predicted_price = float(
        model.predict(df)[0]
    )

    # --------------------------------------------------------
    # Confidence + price range
    # --------------------------------------------------------

    metrics = load_model_metrics(crop)

    best_model = metrics["best_model"]

    if best_model == "Linear Regression":

        model_metrics = metrics["linear_regression"]

    elif best_model == "Random Forest":

        model_metrics = metrics["random_forest"]

    else:

        model_metrics = metrics["xgboost"]

    mae = float(
        model_metrics["MAE"]
    )

    r2 = float(
        model_metrics["R2"]
    )

    lower_price = (
        predicted_price - mae
    )

    upper_price = (
        predicted_price + mae
    )

    confidence = (
        r2 * 100
    )

    # Keep confidence within a sensible range
    confidence = max(
        0.0,
        min(100.0, confidence)
    )

    # --------------------------------------------------------
    # Current price
    # --------------------------------------------------------

    current_price = float(
        input_data["Modal_Price"]
    )

    # --------------------------------------------------------
    # Profit Engine
    # --------------------------------------------------------

    profit_analysis = calculate_profit(

        quantity=quantity,

        current_price=current_price,

        predicted_price=predicted_price,

        transport_cost=transport_cost,

        storage_cost=storage_expense

    )

    # --------------------------------------------------------
    # Decision Engine
    # --------------------------------------------------------

    result = decide_sale(

        crop=crop,

        prediction_horizon_days=HORIZONS[crop],

        current_price=current_price,

        predicted_price=predicted_price,

        expected_price_range={

            "lower": lower_price,

            "upper": upper_price

        },

        storage_available=storage_available,

        storage_cost=storage_cost,

        demand_level=demand_level,

        quantity=quantity,

        confidence_score=confidence,

        profit_analysis=profit_analysis

    )

    # --------------------------------------------------------
    # Add Intelligence Outputs
    # --------------------------------------------------------

    result["crop"] = crop

    result["current_price"] = round(
        current_price,
        2
    )

    result["predicted_price"] = round(
        predicted_price,
        2
    )

    result["expected_price_range"] = {

        "lower": round(
            lower_price,
            2
        ),

        "upper": round(
            upper_price,
            2
        )

    }

    result["confidence_score"] = round(
        confidence,
        2
    )

    result["prediction_horizon_days"] = HORIZONS[crop]

    # --------------------------------------------------------
    # Farmer Explanation
    # --------------------------------------------------------

    explanation = generate_farmer_explanation(

        recommendation=result["recommendation"],

        reasons=result["reasons"],

        profit_analysis=result["profit_analysis"],

        quantity_strategy=result["quantity_strategy"],

        crop=crop,

        confidence_score=result["confidence_score"]

    )

    result["farmer_explanation"] = explanation

    return result


# ============================================================
# LIVE BACKEND WRAPPER
# ============================================================

def predict_from_market_history(

    crop,

    market,

    variety,

    grade,

    history,

    storage_available,

    storage_cost,

    demand_level,

    quantity,

    transport_cost,

    storage_expense

):

    # --------------------------------------------------------
    # Validate historical data
    # --------------------------------------------------------

    if not history:

        raise Exception(
            "No historical market data provided."
        )

    # --------------------------------------------------------
    # Generate the 33 ML features
    # --------------------------------------------------------

    input_data = build_features(

        crop=crop,

        market=market,

        variety=variety,

        grade=grade,

        history=history

    )

    # --------------------------------------------------------
    # Run existing Intelligence pipeline
    # --------------------------------------------------------

    result = predict_market_decision(

        crop=crop,

        input_data=input_data,

        storage_available=storage_available,

        storage_cost=storage_cost,

        demand_level=demand_level,

        quantity=quantity,

        transport_cost=transport_cost,

        storage_expense=storage_expense

    )

    return result
