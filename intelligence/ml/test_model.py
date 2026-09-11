from pathlib import Path
import pandas as pd
import numpy as np
import joblib
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score


# ============================================================
# FARMORA - MODEL TESTING
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent

PROCESSED_DIR = BASE_DIR / "data" / "processed"
MODELS_DIR = BASE_DIR / "models"


# ============================================================
# CROP LIST
# ============================================================

CROPS = [
    "cotton",
    "rice",
    "sugarcane",
    "wheat",
    "onion",
    "tomato",
]


# ============================================================
# FEATURES USED DURING TRAINING
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
# TEST ONE CROP
# ============================================================

def test_crop(crop):

    print("\n" + "=" * 70)
    print(f"TESTING MODEL: {crop.upper()}")
    print("=" * 70)

    feature_file = (
        PROCESSED_DIR
        / f"{crop}_features.csv"
    )

    model_file = (
        MODELS_DIR
        / f"{crop}_price_model.joblib"
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
    # Load data
    # --------------------------------------------------------

    df = pd.read_csv(
        feature_file
    )

    df["Arrival_Date"] = pd.to_datetime(
        df["Arrival_Date"],
        errors="coerce"
    )

    # --------------------------------------------------------
    # Convert target
    # --------------------------------------------------------

    df["Target_Price"] = pd.to_numeric(
        df["Target_Price"],
        errors="coerce"
    )

    # --------------------------------------------------------
    # Keep only rows with actual future price
    # --------------------------------------------------------

    df = df.dropna(
        subset=[
            "Arrival_Date",
            "Modal_Price",
            "Target_Price",
        ]
    )

    # --------------------------------------------------------
    # Sort chronologically
    # --------------------------------------------------------

    df = df.sort_values(
        "Arrival_Date"
    ).reset_index(
        drop=True
    )

    # --------------------------------------------------------
    # IMPORTANT:
    #
    # Use the same chronological 80/20 split
    # used during training.
    #
    # We ONLY test on the final 20%.
    # --------------------------------------------------------

    split_index = int(
        len(df) * 0.80
    )

    test_df = df.iloc[
        split_index:
    ].copy()

    # --------------------------------------------------------
    # Check features
    # --------------------------------------------------------

    missing_features = [
        column
        for column in FEATURE_COLUMNS
        if column not in test_df.columns
    ]

    if missing_features:

        print("\n❌ Missing features:")

        for feature in missing_features:
            print(
                f"   - {feature}"
            )

        return None

    # --------------------------------------------------------
    # Load trained model
    # --------------------------------------------------------

    model = joblib.load(
        model_file
    )

    # --------------------------------------------------------
    # Prepare X and y
    # --------------------------------------------------------

    X_test = test_df[
        FEATURE_COLUMNS
    ]

    y_test = test_df[
        "Target_Price"
    ]

    # --------------------------------------------------------
    # Predict
    # --------------------------------------------------------

    predictions = model.predict(
        X_test
    )

    predictions = np.asarray(
        predictions,
        dtype=float
    )

    actual = np.asarray(
        y_test,
        dtype=float
    )

    # --------------------------------------------------------
    # Metrics
    # --------------------------------------------------------

    mae = mean_absolute_error(
        actual,
        predictions
    )

    rmse = np.sqrt(
        mean_squared_error(
            actual,
            predictions
        )
    )

    r2 = r2_score(
        actual,
        predictions
    )

    # --------------------------------------------------------
    # Percentage error
    # --------------------------------------------------------

    non_zero = actual != 0

    percentage_errors = (
        np.abs(
            predictions[non_zero]
            - actual[non_zero]
        )
        /
        np.abs(
            actual[non_zero]
        )
    ) * 100

    mean_percentage_error = (
        percentage_errors.mean()
    )

    within_10_percent = (
        percentage_errors <= 10
    ).mean() * 100

    within_20_percent = (
        percentage_errors <= 20
    ).mean() * 100

    # --------------------------------------------------------
    # Display metrics
    # --------------------------------------------------------

    print(
        f"\nTotal usable observations: "
        f"{len(df)}"
    )

    print(
        f"Testing observations: "
        f"{len(test_df)}"
    )

    print(
        f"Test period: "
        f"{test_df['Arrival_Date'].min().date()}"
        f" to "
        f"{test_df['Arrival_Date'].max().date()}"
    )

    print("\nMODEL PERFORMANCE")
    print("-" * 70)

    print(
        f"MAE: "
        f"₹{mae:.2f}"
    )

    print(
        f"RMSE: "
        f"₹{rmse:.2f}"
    )

    print(
        f"R²: "
        f"{r2:.4f}"
    )

    print(
        f"Mean Percentage Error: "
        f"{mean_percentage_error:.2f}%"
    )

    print(
        f"Predictions within 10%: "
        f"{within_10_percent:.2f}%"
    )

    print(
        f"Predictions within 20%: "
        f"{within_20_percent:.2f}%"
    )

    # --------------------------------------------------------
    # Actual vs predicted examples
    # --------------------------------------------------------

    test_df["Predicted_Price"] = (
        predictions
    )

    test_df["Absolute_Error"] = (
        np.abs(
            test_df["Target_Price"]
            - test_df["Predicted_Price"]
        )
    )

    test_df["Percentage_Error"] = (
        np.abs(
            test_df["Target_Price"]
            - test_df["Predicted_Price"]
        )
        /
        test_df["Target_Price"].replace(
            0,
            np.nan
        )
    ) * 100

    print("\nSAMPLE PREDICTIONS")
    print("-" * 70)

    sample = test_df[
        [
            "Arrival_Date",
            "Market",
            "Modal_Price",
            "Target_Price",
            "Predicted_Price",
            "Absolute_Error",
            "Percentage_Error",
        ]
    ].tail(10).copy()

    sample["Arrival_Date"] = (
        sample["Arrival_Date"]
        .dt.strftime("%Y-%m-%d")
    )

    sample = sample.rename(
        columns={
            "Arrival_Date": "Date",
            "Market": "Market",
            "Modal_Price": "Current",
            "Target_Price": "Actual_Future",
            "Predicted_Price": "Predicted",
            "Absolute_Error": "Error",
            "Percentage_Error": "Error_%",
        }
    )

    print(
        sample.to_string(
            index=False
        )
    )

    # --------------------------------------------------------
    # Return summary
    # --------------------------------------------------------

    return {
        "Crop": crop.title(),
        "Test_Samples": len(test_df),
        "MAE": round(mae, 2),
        "RMSE": round(rmse, 2),
        "R2": round(r2, 4),
        "Mean_Percentage_Error": round(
            mean_percentage_error,
            2
        ),
        "Within_10_Percent": round(
            within_10_percent,
            2
        ),
        "Within_20_Percent": round(
            within_20_percent,
            2
        ),
    }


# ============================================================
# MAIN
# ============================================================

def main():

    print("\n")
    print("=" * 70)
    print("FARMORA - MODEL TESTING")
    print("=" * 70)

    results = []

    for crop in CROPS:

        result = test_crop(
            crop
        )

        if result is not None:

            results.append(
                result
            )

    # --------------------------------------------------------
    # Final summary
    # --------------------------------------------------------

    if results:

        results_df = pd.DataFrame(
            results
        )

        output_file = (
            PROCESSED_DIR
            / "model_test_results.csv"
        )

        results_df.to_csv(
            output_file,
            index=False
        )

        print("\n")
        print("=" * 70)
        print("FINAL MODEL TEST SUMMARY")
        print("=" * 70)

        print(
            results_df.to_string(
                index=False
            )
        )

        print("\n")
        print(
            "Testing report saved:"
        )

        print(
            output_file
        )

    else:

        print(
            "\n❌ No models were tested."
        )

    print("\n")
    print("=" * 70)
    print("MODEL TESTING COMPLETE")
    print("=" * 70)


# ============================================================
# RUN
# ============================================================

if __name__ == "__main__":
    main()