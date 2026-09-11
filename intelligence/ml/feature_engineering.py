from pathlib import Path

import pandas as pd


# ============================================================
# FARMORA - FEATURE ENGINEERING
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent

PROCESSED_DIR = BASE_DIR / "data" / "processed"


# ============================================================
# CROP PREDICTION HORIZONS
# ============================================================
#
# These are prototype prediction horizons for Farmora.
#
# Tomato     -> 3 days
# Onion      -> 5 days
# Sugarcane  -> 2 days
# Cotton     -> 14 days
# Rice       -> 14 days
# Wheat      -> 14 days
#
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
# FEATURE FUNCTION
# ============================================================

def create_features(crop):

    print("\n" + "=" * 70)
    print(f"FEATURE ENGINEERING: {crop.upper()}")
    print("=" * 70)

    input_file = (
        PROCESSED_DIR
        / f"{crop}_processed.csv"
    )

    output_file = (
        PROCESSED_DIR
        / f"{crop}_features.csv"
    )

    if not input_file.exists():

        print("❌ Input file not found:")
        print(input_file)

        return False

    # --------------------------------------------------------
    # Read data
    # --------------------------------------------------------

    df = pd.read_csv(input_file)

    print(
        f"Input rows: {len(df)}"
    )

    # --------------------------------------------------------
    # Convert date and price
    # --------------------------------------------------------

    df["Arrival_Date"] = pd.to_datetime(
        df["Arrival_Date"],
        errors="coerce"
    )

    df["Modal_Price"] = pd.to_numeric(
        df["Modal_Price"],
        errors="coerce"
    )

    df["Min_Price"] = pd.to_numeric(
        df["Min_Price"],
        errors="coerce"
    )

    df["Max_Price"] = pd.to_numeric(
        df["Max_Price"],
        errors="coerce"
    )

    # --------------------------------------------------------
    # Remove invalid essential rows
    # --------------------------------------------------------

    df = df.dropna(
        subset=[
            "Arrival_Date",
            "Modal_Price",
        ]
    )

    # --------------------------------------------------------
    # Sort by market series
    # --------------------------------------------------------
    #
    # A series is defined by:
    #
    # Market + Variety
    #
    # Commodity is already fixed because we process one crop
    # at a time.
    #
    # --------------------------------------------------------

    GROUP_COLUMNS = [
    "Market",
    "Variety",
    "Grade",
]

    df = df.sort_values(
        GROUP_COLUMNS + ["Arrival_Date"]
    ).reset_index(drop=True)

    # --------------------------------------------------------
    # Basic price features
    # --------------------------------------------------------

    df["Price_Range"] = (
        df["Max_Price"]
        - df["Min_Price"]
    )

    df["Modal_Position"] = (
        (
            df["Modal_Price"]
            - df["Min_Price"]
        )
        /
        (
            df["Max_Price"]
            - df["Min_Price"]
        )
        .replace(0, pd.NA)
    )

    # --------------------------------------------------------
    # Date features
    # --------------------------------------------------------

    df["Year"] = (
        df["Arrival_Date"].dt.year
    )

    df["Month"] = (
        df["Arrival_Date"].dt.month
    )

    df["Week_Of_Year"] = (
        df["Arrival_Date"].dt.isocalendar().week
    ).astype(int)

    df["Day_Of_Week"] = (
        df["Arrival_Date"].dt.dayofweek
    )

    df["Quarter"] = (
        df["Arrival_Date"].dt.quarter
    )

    # --------------------------------------------------------
    # Group by Market + Variety
    # --------------------------------------------------------

    grouped = df.groupby(
        GROUP_COLUMNS,
        group_keys=False
    )

    # --------------------------------------------------------
    # Lag features
    # --------------------------------------------------------
    #
    # Because markets don't report every calendar day,
    # these represent previous available observations.
    #
    # --------------------------------------------------------

    df["Lag_1"] = grouped[
        "Modal_Price"
    ].shift(1)

    df["Lag_2"] = grouped[
        "Modal_Price"
    ].shift(2)

    df["Lag_3"] = grouped[
        "Modal_Price"
    ].shift(3)

    df["Lag_5"] = grouped[
        "Modal_Price"
    ].shift(5)

    df["Lag_7"] = grouped[
        "Modal_Price"
    ].shift(7)

    df["Lag_14"] = grouped[
        "Modal_Price"
    ].shift(14)

    df["Lag_30"] = grouped[
        "Modal_Price"
    ].shift(30)

    # --------------------------------------------------------
    # Rolling statistics
    # --------------------------------------------------------

    df["Rolling_Mean_3"] = grouped[
        "Modal_Price"
    ].transform(
        lambda x:
        x.shift(1).rolling(
            window=3,
            min_periods=2
        ).mean()
    )

    df["Rolling_Mean_7"] = grouped[
        "Modal_Price"
    ].transform(
        lambda x:
        x.shift(1).rolling(
            window=7,
            min_periods=3
        ).mean()
    )

    df["Rolling_Mean_14"] = grouped[
        "Modal_Price"
    ].transform(
        lambda x:
        x.shift(1).rolling(
            window=14,
            min_periods=5
        ).mean()
    )

    df["Rolling_Mean_30"] = grouped[
        "Modal_Price"
    ].transform(
        lambda x:
        x.shift(1).rolling(
            window=30,
            min_periods=10
        ).mean()
    )

    df["Rolling_Std_7"] = grouped[
        "Modal_Price"
    ].transform(
        lambda x:
        x.shift(1).rolling(
            window=7,
            min_periods=3
        ).std()
    )

    df["Rolling_Std_14"] = grouped[
        "Modal_Price"
    ].transform(
        lambda x:
        x.shift(1).rolling(
            window=14,
            min_periods=5
        ).std()
    )

    # --------------------------------------------------------
    # Price change features
    # --------------------------------------------------------

    df["Price_Change_1"] = (
        df["Modal_Price"]
        - df["Lag_1"]
    )

    df["Price_Change_3"] = (
        df["Modal_Price"]
        - df["Lag_3"]
    )

    df["Price_Change_7"] = (
        df["Modal_Price"]
        - df["Lag_7"]
    )

    df["Price_Change_14"] = (
        df["Modal_Price"]
        - df["Lag_14"]
    )

    # --------------------------------------------------------
    # Percentage changes
    # --------------------------------------------------------

    df["Price_Change_Pct_1"] = (
        (
            df["Modal_Price"]
            - df["Lag_1"]
        )
        /
        df["Lag_1"]
    ) * 100

    df["Price_Change_Pct_7"] = (
        (
            df["Modal_Price"]
            - df["Lag_7"]
        )
        /
        df["Lag_7"]
    ) * 100

    df["Price_Change_Pct_14"] = (
        (
            df["Modal_Price"]
            - df["Lag_14"]
        )
        /
        df["Lag_14"]
    ) * 100

    # --------------------------------------------------------
    # FUTURE PRICE TARGET
    # --------------------------------------------------------
    #
    # We use the actual calendar date:
    #
    # Current date + horizon
    #
    # and look for the same Market + Variety on that date.
    #
    # This is better than simply using shift(-N), because
    # observations are not necessarily daily.
    #
    # --------------------------------------------------------

    horizon = HORIZONS[crop]

    target_columns = [
    "Arrival_Date",
    "Market",
    "Variety",
    "Grade",
    "Modal_Price",
]

    future_df = df[
        target_columns
    ].copy()

    future_df = future_df.drop_duplicates(
    subset=[
        "Arrival_Date",
        "Market",
        "Variety",
        "Grade",
    ]
)

    future_df = future_df.rename(
        columns={
            "Arrival_Date":
                "Target_Date",
            "Modal_Price":
                "Future_Modal_Price",
        }
    )

    # The target date is matched by adding the horizon
    # to the current date.

    df["Target_Date"] = (
        df["Arrival_Date"]
        + pd.to_timedelta(
            horizon,
            unit="D"
        )
    )

    # --------------------------------------------------------
    # Merge future price
    # --------------------------------------------------------

    df = df.merge(
    future_df,
    on=[
        "Target_Date",
        "Market",
        "Variety",
        "Grade",
    ],
    how="left"
)

    # --------------------------------------------------------
    # Target naming
    # --------------------------------------------------------

    df["Target_Price"] = (
        df["Future_Modal_Price"]
    )

    # --------------------------------------------------------
    # Expected future percentage change
    # --------------------------------------------------------
    #
    # This is useful for analysis after prediction.
    #
    # For training, Target_Price is the primary target.
    #
    # --------------------------------------------------------

    df["Actual_Future_Change_Pct"] = (
        (
            df["Target_Price"]
            - df["Modal_Price"]
        )
        /
        df["Modal_Price"]
    ) * 100

    # --------------------------------------------------------
    # Remove duplicate columns if any
    # --------------------------------------------------------

    df = df.loc[
        :,
        ~df.columns.duplicated()
    ]

    # --------------------------------------------------------
    # Sort chronologically
    # --------------------------------------------------------

    df = df.sort_values(
        [
            "Arrival_Date",
            "Market",
            "Variety",
        ]
    ).reset_index(
        drop=True
    )

    # --------------------------------------------------------
    # Save
    # --------------------------------------------------------

    df.to_csv(
        output_file,
        index=False
    )

    # --------------------------------------------------------
    # Report
    # --------------------------------------------------------

    target_available = (
        df["Target_Price"]
        .notna()
        .sum()
    )

    print(
        f"\nPrediction horizon: "
        f"{horizon} days"
    )

    print(
        f"Total rows: "
        f"{len(df)}"
    )

    print(
        f"Rows with future target: "
        f"{target_available}"
    )

    print(
        f"Rows without future target: "
        f"{len(df) - target_available}"
    )

    print(
        f"Features/columns created: "
        f"{len(df.columns)}"
    )

    print(
        f"\nSaved:"
    )

    print(
        output_file
    )

    return True


# ============================================================
# MAIN
# ============================================================

def main():

    print("\n")
    print("=" * 70)
    print("FARMORA - FEATURE ENGINEERING")
    print("=" * 70)

    successful = 0

    for crop in HORIZONS:

        success = create_features(
            crop
        )

        if success:

            successful += 1

    print("\n")
    print("=" * 70)
    print("FEATURE ENGINEERING COMPLETE")
    print("=" * 70)

    print(
        f"Successful crops: "
        f"{successful}/{len(HORIZONS)}"
    )

    print(
        "\nFeature files saved in:"
    )

    print(
        PROCESSED_DIR
    )

    print("=" * 70)


# ============================================================
# RUN
# ============================================================

if __name__ == "__main__":
    main()