import os
import joblib
import pandas as pd

from intelligence.decision_engine import decide_sale


MODEL_DIR = "intelligence/models"


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

    path = (
        f"{MODEL_DIR}/{crop}_price_model.joblib"
    )

    if not os.path.exists(path):
        raise Exception(
            f"Model not found for {crop}"
        )

    return joblib.load(path)



def predict_market_decision(
        crop,
        input_data,
        storage_available,
        storage_cost,
        demand_level,
        quantity
):

    model = load_price_model(crop)


    df = pd.DataFrame(
        [input_data]
    )


    df = df[FEATURES]


    predicted_price = model.predict(df)[0]


    current_price = input_data["Modal_Price"]


    result = decide_sale(
        current_price=current_price,
        predicted_price=predicted_price,
        storage_available=storage_available,
        storage_cost=storage_cost,
        demand_level=demand_level,
        quantity=quantity
    )


    result["crop"] = crop
    result["predicted_price"] = float(
    round(predicted_price, 2)
)


    return result