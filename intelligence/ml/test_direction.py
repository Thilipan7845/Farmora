from pathlib import Path
import pandas as pd
import numpy as np
import joblib


# ============================================================
# FARMORA - PRICE DIRECTION TESTING
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent

PROCESSED_DIR = BASE_DIR / "data" / "processed"
MODELS_DIR = BASE_DIR / "models"


CROPS = [
    "cotton",
    "rice",
    "sugarcane",
    "wheat",
    "onion",
    "tomato",
]


# ============================================================
# FEATURES USED BY THE MODEL
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
    print(f"DIRECTION TEST: {crop.upper()}")
    print("=" * 70)

    feature_file = (
        PROCESSED_DIR
        / f"{crop}_features.csv"
    )

    model_file = (
        MODELS_DIR
        / f"{crop}_price_model.joblib"
    )

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

    df["Modal_Price"] = pd.to_numeric(
        df["Modal_Price"],
        errors="coerce"
    )

    df["Target_Price"] = pd.to_numeric(
        df["Target_Price"],
        errors="coerce"
    )

    # --------------------------------------------------------
    # Keep rows with known actual future price
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
    # Same chronological 80/20 split
    # --------------------------------------------------------

    split_index = int(
        len(df) * 0.80
    )

    test_df = df.iloc[
        split_index:
    ].copy()

    # --------------------------------------------------------
    # Load model
    # --------------------------------------------------------

    model = joblib.load(
        model_file
    )

    # --------------------------------------------------------
    # Prepare test data
    # --------------------------------------------------------

    X_test = test_df[
        FEATURE_COLUMNS
    ]

    # --------------------------------------------------------
    # Generate predictions
    # --------------------------------------------------------

    predictions = model.predict(
        X_test
    )

    test_df["Predicted_Price"] = (
        predictions
    )

    # ========================================================
    # ACTUAL DIRECTION
    # ========================================================

    test_df["Actual_Direction"] = np.where(
        test_df["Target_Price"]
        > test_df["Modal_Price"],
        "RISING",
        np.where(
            test_df["Target_Price"]
            < test_df["Modal_Price"],
            "FALLING",
            "STABLE"
        )
    )

    # ========================================================
    # PREDICTED DIRECTION
    # ========================================================

    test_df["Predicted_Direction"] = np.where(
        test_df["Predicted_Price"]
        > test_df["Modal_Price"],
        "RISING",
        np.where(
            test_df["Predicted_Price"]
            < test_df["Modal_Price"],
            "FALLING",
            "STABLE"
        )
    )

    # ========================================================
    # DIRECTION CORRECT?
    # ========================================================

    test_df["Direction_Correct"] = (
        test_df["Actual_Direction"]
        ==
        test_df["Predicted_Direction"]
    )

    # --------------------------------------------------------
    # Overall direction accuracy
    # --------------------------------------------------------

    direction_accuracy = (
        test_df["Direction_Correct"]
        .mean()
        * 100
    )

    # --------------------------------------------------------
    # Rising accuracy
    # --------------------------------------------------------

    actual_rising = (
        test_df["Actual_Direction"]
        == "RISING"
    )

    if actual_rising.sum() > 0:

        rising_correct = (
            (
                test_df.loc[
                    actual_rising,
                    "Predicted_Direction"
                ]
                == "RISING"
            )
            .mean()
            * 100
        )

    else:

        rising_correct = 0

    # --------------------------------------------------------
    # Falling accuracy
    # --------------------------------------------------------

    actual_falling = (
        test_df["Actual_Direction"]
        == "FALLING"
    )

    if actual_falling.sum() > 0:

        falling_correct = (
            (
                test_df.loc[
                    actual_falling,
                    "Predicted_Direction"
                ]
                == "FALLING"
            )
            .mean()
            * 100
        )

    else:

        falling_correct = 0

    # --------------------------------------------------------
    # Direction counts
    # --------------------------------------------------------

    rising_count = (
        (
            test_df["Actual_Direction"]
            == "RISING"
        )
        .sum()
    )

    falling_count = (
        (
            test_df["Actual_Direction"]
            == "FALLING"
        )
        .sum()
    )

    stable_count = (
        (
            test_df["Actual_Direction"]
            == "STABLE"
        )
        .sum()
    )

    # --------------------------------------------------------
    # Display
    # --------------------------------------------------------

    print(
        f"\nTest samples: "
        f"{len(test_df)}"
    )

    print(
        f"\nActual direction distribution:"
    )

    print(
        f"RISING:  {rising_count}"
    )

    print(
        f"FALLING: {falling_count}"
    )

    print(
        f"STABLE:  {stable_count}"
    )

    print("\nDIRECTION PERFORMANCE")
    print("-" * 70)

    print(
        f"Overall Direction Accuracy: "
        f"{direction_accuracy:.2f}%"
    )

    print(
        f"Rising Direction Accuracy: "
        f"{rising_correct:.2f}%"
    )

    print(
        f"Falling Direction Accuracy: "
        f"{falling_correct:.2f}%"
    )

    # --------------------------------------------------------
    # Sample predictions
    # --------------------------------------------------------

    print("\nSAMPLE DIRECTION PREDICTIONS")
    print("-" * 70)

    sample = test_df[
        [
            "Arrival_Date",
            "Market",
            "Modal_Price",
            "Target_Price",
            "Predicted_Price",
            "Actual_Direction",
            "Predicted_Direction",
            "Direction_Correct",
        ]
    ].tail(10).copy()

    sample["Arrival_Date"] = (
        sample["Arrival_Date"]
        .dt.strftime("%Y-%m-%d")
    )

    print(
        sample.to_string(
            index=False
        )
    )

    # --------------------------------------------------------
    # Return result
    # --------------------------------------------------------

    return {
        "Crop": crop.title(),
        "Test_Samples": len(test_df),
        "Direction_Accuracy": round(
            direction_accuracy,
            2
        ),
        "Rising_Accuracy": round(
            rising_correct,
            2
        ),
        "Falling_Accuracy": round(
            falling_correct,
            2
        ),
        "Actual_Rising": int(
            rising_count
        ),
        "Actual_Falling": int(
            falling_count
        ),
        "Actual_Stable": int(
            stable_count
        ),
    }


# ============================================================
# MAIN
# ============================================================

def main():

    print("\n")
    print("=" * 70)
    print("FARMORA - PRICE DIRECTION TESTING")
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
            / "direction_test_results.csv"
        )

        results_df.to_csv(
            output_file,
            index=False
        )

        print("\n")
        print("=" * 70)
        print("FINAL DIRECTION TEST SUMMARY")
        print("=" * 70)

        print(
            results_df.to_string(
                index=False
            )
        )

        print("\n")
        print(
            "Direction testing report saved:"
        )

        print(
            output_file
        )

    else:

        print(
            "\n❌ No direction results generated."
        )

    print("\n")
    print("=" * 70)
    print("DIRECTION TESTING COMPLETE")
    print("=" * 70)


# ============================================================
# RUN
# ============================================================

if __name__ == "__main__":
    main()