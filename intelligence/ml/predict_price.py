from pathlib import Path
import json
import pandas as pd
import joblib


# ============================================================
# FARMORA - PRICE PREDICTION
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent

PROCESSED_DIR = BASE_DIR / "data" / "processed"
MODELS_DIR = BASE_DIR / "models"


# ============================================================
# CROP PREDICTION HORIZONS
# ============================================================

HORIZONS = {
    "cotton": 14,
    "rice": 14,
    "sugarcane": 2,
    "wheat": 14,
    "onion": 5,
    "tomato": 3,
}


# ============================================================
# MODEL FEATURES
# ============================================================

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

FEATURE_COLUMNS = (
    NUMERIC_FEATURES
    + CATEGORICAL_FEATURES
)


# ============================================================
# TREND THRESHOLD
# ============================================================

TREND_THRESHOLD = 2.0


# ============================================================
# PREDICT ONE CROP
# ============================================================

def predict_crop(crop):

    print("\n" + "=" * 70)
    print(f"PRICE PREDICTION: {crop.upper()}")
    print("=" * 70)

    feature_file = (
        PROCESSED_DIR
        / f"{crop}_features.csv"
    )

    model_file = (
        MODELS_DIR
        / f"{crop}_price_model.joblib"
    )

    metrics_file = (
        MODELS_DIR
        / f"{crop}_metrics.json"
    )

    # --------------------------------------------------------
    # Check files
    # --------------------------------------------------------

    if not feature_file.exists():
        print("❌ Feature file not found:")
        print(feature_file)
        return None

    if not model_file.exists():
        print("❌ Model file not found:")
        print(model_file)
        return None

    # --------------------------------------------------------
    # Load model
    # --------------------------------------------------------

    model = joblib.load(
        model_file
    )

    # --------------------------------------------------------
    # Load metrics if available
    # --------------------------------------------------------

    metrics = {}

    if metrics_file.exists():

        with open(
            metrics_file,
            "r",
            encoding="utf-8"
        ) as f:

            metrics = json.load(f)

    # --------------------------------------------------------
    # Load feature data
    # --------------------------------------------------------

    df = pd.read_csv(
        feature_file
    )

    df["Arrival_Date"] = pd.to_datetime(
        df["Arrival_Date"],
        errors="coerce"
    )

    df["Modal_Price"] = pd.to_numeric(
        df["Modal_Price"],
        errors="coerce"
    )

    # --------------------------------------------------------
    # Remove invalid rows
    # --------------------------------------------------------

    df = df.dropna(
        subset=[
            "Arrival_Date",
            "Modal_Price",
        ]
    )

    # --------------------------------------------------------
    # Check required columns
    # --------------------------------------------------------

    missing_features = [
        column
        for column in FEATURE_COLUMNS
        if column not in df.columns
    ]

    if missing_features:

        print("\n❌ Missing model features:")

        for feature in missing_features:
            print(
                f"   - {feature}"
            )

        return None

    # --------------------------------------------------------
    # Sort by date
    # --------------------------------------------------------

    df = df.sort_values(
        "Arrival_Date"
    ).reset_index(
        drop=True
    )

    # --------------------------------------------------------
    # Latest observation
    # --------------------------------------------------------

    latest = df.iloc[-1]

    # --------------------------------------------------------
    # Prepare input
    # --------------------------------------------------------

    X = pd.DataFrame(
        [latest[FEATURE_COLUMNS]]
    )

    # --------------------------------------------------------
    # Prediction
    # --------------------------------------------------------

    predicted_price = model.predict(
        X
    )[0]

    current_price = float(
        latest["Modal_Price"]
    )

    predicted_price = float(
        predicted_price
    )

    # --------------------------------------------------------
    # Expected percentage change
    # --------------------------------------------------------

    if current_price != 0:

        expected_change = (
            (
                predicted_price
                - current_price
            )
            / current_price
        ) * 100

    else:

        expected_change = 0.0

    # --------------------------------------------------------
    # Trend
    # --------------------------------------------------------

    if expected_change > TREND_THRESHOLD:

        trend = "RISING"

    elif expected_change < -TREND_THRESHOLD:

        trend = "FALLING"

    else:

        trend = "STABLE"

    # --------------------------------------------------------
    # Dates
    # --------------------------------------------------------

    current_date = latest[
        "Arrival_Date"
    ]

    prediction_date = (
        current_date
        + pd.Timedelta(
            days=HORIZONS[crop]
        )
    )

    # --------------------------------------------------------
    # Market information
    # --------------------------------------------------------

    market = str(
        latest.get(
            "Market",
            "Unknown"
        )
    )

    variety = str(
        latest.get(
            "Variety",
            "Unknown"
        )
    )

    grade = str(
        latest.get(
            "Grade",
            "Unknown"
        )
    )

    # --------------------------------------------------------
    # Model name
    # --------------------------------------------------------

    model_name = metrics.get(
        "best_model",
        "Saved Model"
    )

    # --------------------------------------------------------
    # Display result
    # --------------------------------------------------------

    print(
        f"\nCrop: {crop.upper()}"
    )

    print(
        f"Market: {market}"
    )

    print(
        f"Variety: {variety}"
    )

    print(
        f"Grade: {grade}"
    )

    print(
        f"Current Date: "
        f"{current_date.strftime('%Y-%m-%d')}"
    )

    print(
        f"Prediction Date: "
        f"{prediction_date.strftime('%Y-%m-%d')}"
    )

    print(
        f"Prediction Horizon: "
        f"{HORIZONS[crop]} days"
    )

    print(
        f"Current Price: "
        f"₹{current_price:.2f}"
    )

    print(
        f"Predicted Future Price: "
        f"₹{predicted_price:.2f}"
    )

    print(
        f"Expected Change: "
        f"{expected_change:+.2f}%"
    )

    print(
        f"Trend: "
        f"{trend}"
    )

    print(
        f"Model: "
        f"{model_name}"
    )

    # --------------------------------------------------------
    # Return result
    # --------------------------------------------------------

    return {
        "Crop": crop.title(),
        "Market": market,
        "Variety": variety,
        "Grade": grade,
        "Current_Date": current_date.strftime(
            "%Y-%m-%d"
        ),
        "Prediction_Date": prediction_date.strftime(
            "%Y-%m-%d"
        ),
        "Prediction_Horizon_Days": HORIZONS[crop],
        "Current_Price": round(
            current_price,
            2
        ),
        "Predicted_Future_Price": round(
            predicted_price,
            2
        ),
        "Expected_Change_Pct": round(
            expected_change,
            2
        ),
        "Trend": trend,
        "Model": model_name,
    }


# ============================================================
# MAIN
# ============================================================

def main():

    print("\n")
    print("=" * 70)
    print("FARMORA - MARKET PRICE PREDICTION")
    print("=" * 70)

    results = []

    for crop in HORIZONS:

        result = predict_crop(
            crop
        )

        if result is not None:

            results.append(
                result
            )

    # --------------------------------------------------------
    # Save predictions
    # --------------------------------------------------------

    if results:

        results_df = pd.DataFrame(
            results
        )

        output_file = (
            PROCESSED_DIR
            / "latest_predictions.csv"
        )

        results_df.to_csv(
            output_file,
            index=False
        )

        print("\n")
        print("=" * 70)
        print("FARMORA PREDICTION SUMMARY")
        print("=" * 70)

        print(
            results_df[
                [
                    "Crop",
                    "Market",
                    "Current_Price",
                    "Predicted_Future_Price",
                    "Expected_Change_Pct",
                    "Trend",
                ]
            ].to_string(
                index=False
            )
        )

        print("\nPrediction file saved:")
        print(output_file)

    else:

        print(
            "\n❌ No predictions generated."
        )

    print("\n" + "=" * 70)
    print("PREDICTION COMPLETE")
    print("=" * 70)


# ============================================================
# RUN
# ============================================================

if __name__ == "__main__":
    main()