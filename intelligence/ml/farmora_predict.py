import os
import json
import joblib
import pandas as pd

from decision_engine import decide_sale


MODEL_DIR = "intelligence/models"


# Crop prediction horizons
HORIZONS = {
    "cotton": 14,
    "rice": 14,
    "sugarcane": 2,
    "wheat": 14,
    "onion": 5,
    "tomato": 3
}


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



def load_price_model(crop):

    crop = crop.lower()

    path = (
        f"{MODEL_DIR}/{crop}_price_model.joblib"
    )


    if not os.path.exists(path):

        raise Exception(
            f"Model not found for {crop}"
        )


    return joblib.load(path)




def load_model_metrics(crop):

    path = (
        f"{MODEL_DIR}/{crop}_metrics.json"
    )


    if not os.path.exists(path):

        raise Exception(
            f"Metrics not found for {crop}"
        )


    with open(
        path,
        "r"
    ) as file:

        return json.load(file)





def predict_market_decision(
        crop,
        input_data,
        storage_available,
        storage_cost,
        demand_level,
        quantity
):

    crop = crop.lower()



    # -----------------------------
    # Load model
    # -----------------------------

    model = load_price_model(crop)



    # -----------------------------
    # Prepare input
    # -----------------------------

    df = pd.DataFrame(
        [input_data]
    )


    df = df[FEATURES]



    # -----------------------------
    # Predict future price
    # -----------------------------

    predicted_price = model.predict(df)[0]



    # -----------------------------
    # Price range + confidence
    # -----------------------------

    metrics = load_model_metrics(crop)


    best_model = metrics[
        "best_model"
    ]


    if best_model == "Linear Regression":

        model_metrics = metrics[
            "linear_regression"
        ]


    elif best_model == "Random Forest":

        model_metrics = metrics[
            "random_forest"
        ]


    else:

        model_metrics = metrics[
            "xgboost"
        ]



    mae = model_metrics[
        "MAE"
    ]


    r2 = model_metrics[
        "R2"
    ]



    lower_price = (
        predicted_price - mae
    )


    upper_price = (
        predicted_price + mae
    )


    confidence = (
        r2 * 100
    )



    # -----------------------------
    # Current price
    # -----------------------------

    current_price = input_data[
        "Modal_Price"
    ]



    # -----------------------------
    # Decision engine
    # -----------------------------

    result = decide_sale(

    crop=crop,

    prediction_horizon_days=HORIZONS[crop],

    current_price=current_price,

    predicted_price=predicted_price,

    storage_available=storage_available,

    storage_cost=storage_cost,

    demand_level=demand_level,

    quantity=quantity,

    confidence_score=confidence
    )


    # -----------------------------
    # Add prediction intelligence
    # -----------------------------

    result["predicted_price"] = float(
        round(predicted_price, 2)
    )


    result["expected_price_range"] = {

        "lower":
            float(round(lower_price, 2)),

        "upper":
            float(round(upper_price, 2))

    }


    result["confidence_score"] = float(
        round(confidence, 2)
    )



    return result