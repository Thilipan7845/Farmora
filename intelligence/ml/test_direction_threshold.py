import pandas as pd
import joblib
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[1]

CROPS = {
    "cotton": 14,
    "rice": 14,
    "sugarcane": 2,
    "wheat": 14,
    "onion": 5,
    "tomato": 3,
}

NUMERIC_FEATURES = [
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
]

CATEGORICAL_FEATURES = [
    "Market",
    "Variety",
    "Grade",
]

FEATURES = NUMERIC_FEATURES + CATEGORICAL_FEATURES


def classify(change_percent, threshold):
    if change_percent >= threshold:
        return "RISING"
    elif change_percent <= -threshold:
        return "FALLING"
    else:
        return "STABLE"


for crop, horizon in CROPS.items():

    print("\n" + "=" * 60)
    print(crop.upper())
    print("=" * 60)

    feature_file = (
        BASE_DIR / "data" / "processed" / f"{crop}_features.csv"
    )

    model_file = (
        BASE_DIR / "models" / f"{crop}_price_model.joblib"
    )

    if not feature_file.exists():
        print("Feature file not found:", feature_file)
        continue

    if not model_file.exists():
        print("Model file not found:", model_file)
        continue

    df = pd.read_csv(feature_file)

    df["Arrival_Date"] = pd.to_datetime(
        df["Arrival_Date"],
        errors="coerce"
    )

    df = df.dropna(
        subset=["Target_Price", "Modal_Price"]
    ).copy()

    # Use the same final chronological 20% test period
    df = df.sort_values("Arrival_Date").reset_index(drop=True)

    split_index = int(len(df) * 0.8)

    test_df = df.iloc[split_index:].copy()

    if len(test_df) == 0:
        print("Not enough test data.")
        continue

    X_test = test_df[FEATURES]

    model = joblib.load(model_file)

    predictions = model.predict(X_test)

    test_df["Predicted_Price"] = predictions

    # Predicted percentage movement
    test_df["Predicted_Change_Pct"] = (
        (test_df["Predicted_Price"] - test_df["Modal_Price"])
        / test_df["Modal_Price"]
    ) * 100

    # Actual percentage movement
    test_df["Actual_Change_Pct"] = (
        (test_df["Target_Price"] - test_df["Modal_Price"])
        / test_df["Modal_Price"]
    ) * 100

    print(f"Test samples: {len(test_df)}")

    for threshold in [1.0, 2.0, 3.0, 5.0]:

        test_df["Predicted_Trend"] = test_df[
            "Predicted_Change_Pct"
        ].apply(
            lambda x: classify(x, threshold)
        )

        test_df["Actual_Trend"] = test_df[
            "Actual_Change_Pct"
        ].apply(
            lambda x: classify(x, threshold)
        )

        accuracy = (
            test_df["Predicted_Trend"]
            == test_df["Actual_Trend"]
        ).mean() * 100

        print(
            f"Threshold {threshold:.0f}% "
            f"-> Direction accuracy: {accuracy:.2f}%"
        )

    # Detailed result for the Farmora 2% threshold
    threshold = 2.0

    test_df["Predicted_Trend"] = test_df[
        "Predicted_Change_Pct"
    ].apply(
        lambda x: classify(x, threshold)
    )

    test_df["Actual_Trend"] = test_df[
        "Actual_Change_Pct"
    ].apply(
        lambda x: classify(x, threshold)
    )

    print("\n2% THRESHOLD BREAKDOWN")

    print(
        pd.crosstab(
            test_df["Actual_Trend"],
            test_df["Predicted_Trend"]
        )
    )

    print("\nPredicted trend counts:")
    print(test_df["Predicted_Trend"].value_counts())

    print("\nActual trend counts:")
    print(test_df["Actual_Trend"].value_counts())