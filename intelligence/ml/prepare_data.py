import os
from pathlib import Path

import pandas as pd


# ============================================================
# FARMORA - DATA PREPARATION
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent

RAW_DIR = BASE_DIR / "data" / "raw"

RECENT_DIR = RAW_DIR / "recent"

PROCESSED_DIR = BASE_DIR / "data" / "processed"

PROCESSED_DIR.mkdir(
    parents=True,
    exist_ok=True
)


# ============================================================
# CROPS
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
# COLUMNS WE EXPECT FROM DATA.GOV.IN
# ============================================================

EXPECTED_COLUMNS = [
    "Arrival_Date",
    "Commodity",
    "Commodity_Code",
    "District",
    "Grade",
    "Market",
    "Max_Price",
    "Min_Price",
    "Modal_Price",
    "State",
    "Variety",
]


# ============================================================
# PREPARE ONE CROP
# ============================================================

def prepare_crop(crop):

    print("\n" + "=" * 70)
    print(f"PREPARING: {crop.upper()}")
    print("=" * 70)

    historical_file = (
        RAW_DIR
        / f"{crop}_maharashtra.csv"
    )

    recent_file = (
        RECENT_DIR
        / f"{crop}_recent.csv"
    )

    # --------------------------------------------------------
    # Check files
    # --------------------------------------------------------

    if not historical_file.exists():

        print(
            f"Historical file not found:"
        )

        print(
            historical_file
        )

        return False

    if not recent_file.exists():

        print(
            f"Recent file not found:"
        )

        print(
            recent_file
        )

        return False

    # --------------------------------------------------------
    # Read files
    # --------------------------------------------------------

    try:

        historical_df = pd.read_csv(
            historical_file
        )

        recent_df = pd.read_csv(
            recent_file
        )

    except Exception as e:

        print(
            "ERROR reading files:"
        )

        print(e)

        return False

    print(
        f"Historical rows: "
        f"{len(historical_df)}"
    )

    print(
        f"Recent rows: "
        f"{len(recent_df)}"
    )

    # --------------------------------------------------------
    # Combine
    # --------------------------------------------------------

    df = pd.concat(
        [
            historical_df,
            recent_df
        ],
        ignore_index=True
    )

    print(
        f"Combined rows: "
        f"{len(df)}"
    )

    # --------------------------------------------------------
    # Clean column names
    # --------------------------------------------------------

    df.columns = [
        str(column).strip()
        for column in df.columns
    ]

    # --------------------------------------------------------
    # Check expected columns
    # --------------------------------------------------------

    missing_columns = [
        column
        for column in EXPECTED_COLUMNS
        if column not in df.columns
    ]

    if missing_columns:

        print(
            "WARNING - Missing columns:"
        )

        print(
            missing_columns
        )

    # --------------------------------------------------------
    # Convert date
    # --------------------------------------------------------

    if "Arrival_Date" in df.columns:

        df["Arrival_Date"] = pd.to_datetime(
            df["Arrival_Date"],
            errors="coerce"
        )

    # --------------------------------------------------------
    # Convert price columns
    # --------------------------------------------------------

    price_columns = [
        "Min_Price",
        "Max_Price",
        "Modal_Price",
    ]

    for column in price_columns:

        if column in df.columns:

            df[column] = pd.to_numeric(
                df[column],
                errors="coerce"
            )

    # --------------------------------------------------------
    # Count invalid values BEFORE removing them
    # --------------------------------------------------------

    print("\nInvalid values before cleaning:")

    if "Arrival_Date" in df.columns:

        print(
            "Invalid dates:",
            df["Arrival_Date"].isna().sum()
        )

    for column in price_columns:

        if column in df.columns:

            print(
                f"Invalid {column}:",
                df[column].isna().sum()
            )

    # --------------------------------------------------------
    # Remove rows without essential information
    # --------------------------------------------------------

    essential_columns = [
        "Arrival_Date",
        "Modal_Price",
    ]

    existing_essential = [
        column
        for column in essential_columns
        if column in df.columns
    ]

    df = df.dropna(
        subset=existing_essential
    )

    # --------------------------------------------------------
    # Remove impossible/non-positive prices
    # --------------------------------------------------------

    if "Modal_Price" in df.columns:

        df = df[
            df["Modal_Price"] > 0
        ]

    if "Min_Price" in df.columns:

        df = df[
            df["Min_Price"] > 0
        ]

    if "Max_Price" in df.columns:

        df = df[
            df["Max_Price"] > 0
        ]

    # --------------------------------------------------------
    # Remove logically inconsistent price records
    # --------------------------------------------------------

    if all(
        column in df.columns
        for column in [
            "Min_Price",
            "Modal_Price",
            "Max_Price"
        ]
    ):

        df = df[
            (df["Min_Price"] <= df["Modal_Price"])
            &
            (df["Modal_Price"] <= df["Max_Price"])
        ]

    # --------------------------------------------------------
    # Remove exact duplicate records
    # --------------------------------------------------------

    before_duplicates = len(df)

    df = df.drop_duplicates()

    duplicates_removed = (
        before_duplicates
        - len(df)
    )

    print(
        f"\nDuplicate rows removed: "
        f"{duplicates_removed}"
    )

    # --------------------------------------------------------
    # Sort by date
    # --------------------------------------------------------

    df = df.sort_values(
        "Arrival_Date"
    ).reset_index(
        drop=True
    )

    # --------------------------------------------------------
    # Keep expected columns first
    # --------------------------------------------------------

    available_expected = [
        column
        for column in EXPECTED_COLUMNS
        if column in df.columns
    ]

    other_columns = [
        column
        for column in df.columns
        if column not in available_expected
    ]

    df = df[
        available_expected
        + other_columns
    ]

    # --------------------------------------------------------
    # Save processed dataset
    # --------------------------------------------------------

    output_file = (
        PROCESSED_DIR
        / f"{crop}_processed.csv"
    )

    df.to_csv(
        output_file,
        index=False
    )

    # --------------------------------------------------------
    # Final information
    # --------------------------------------------------------

    print(
        f"\nFinal rows: "
        f"{len(df)}"
    )

    print(
        f"Final columns: "
        f"{len(df.columns)}"
    )

    if "Arrival_Date" in df.columns:

        print(
            f"Date from: "
            f"{df['Arrival_Date'].min().date()}"
        )

        print(
            f"Date to:   "
            f"{df['Arrival_Date'].max().date()}"
        )

    if "Modal_Price" in df.columns:

        print(
            f"Modal price min: "
            f"{df['Modal_Price'].min()}"
        )

        print(
            f"Modal price max: "
            f"{df['Modal_Price'].max()}"
        )

        print(
            f"Modal price mean: "
            f"{df['Modal_Price'].mean():.2f}"
        )

    print(
        f"\nSAVED:"
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
    print("FARMORA - PROCESSING MARKET DATA")
    print("=" * 70)

    print(
        f"Raw directory:"
    )

    print(
        RAW_DIR
    )

    print(
        f"\nRecent directory:"
    )

    print(
        RECENT_DIR
    )

    print(
        f"\nProcessed directory:"
    )

    print(
        PROCESSED_DIR
    )

    print("=" * 70)

    successful = 0

    failed = 0

    for crop in CROPS:

        success = prepare_crop(
            crop
        )

        if success:

            successful += 1

        else:

            failed += 1

    # --------------------------------------------------------
    # Summary
    # --------------------------------------------------------

    print("\n")
    print("=" * 70)
    print("DATA PREPARATION COMPLETE")
    print("=" * 70)

    print(
        f"Successful crops: "
        f"{successful}/{len(CROPS)}"
    )

    print(
        f"Failed crops: "
        f"{failed}"
    )

    print(
        f"\nProcessed files are in:"
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