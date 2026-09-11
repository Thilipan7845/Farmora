from pathlib import Path
import pandas as pd


# ============================================================
# FARMORA - PROCESSED DATA INSPECTION
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent

PROCESSED_DIR = BASE_DIR / "data" / "processed"

CROPS = [
    "cotton",
    "rice",
    "sugarcane",
    "wheat",
    "onion",
    "tomato",
]


print("\n" + "=" * 70)
print("FARMORA - PROCESSED DATA INSPECTION")
print("=" * 70)

print(f"Processed folder:")
print(PROCESSED_DIR)


for crop in CROPS:

    print("\n" + "-" * 70)
    print(f"CROP: {crop.upper()}")
    print("-" * 70)

    file_path = (
        PROCESSED_DIR
        / f"{crop}_processed.csv"
    )

    if not file_path.exists():

        print("❌ File not found:")
        print(file_path)

        continue

    try:

        df = pd.read_csv(file_path)

        print(f"\nRows: {len(df)}")
        print(f"Columns: {len(df.columns)}")

        # ----------------------------------------------------
        # Date information
        # ----------------------------------------------------

        if "Arrival_Date" in df.columns:

            dates = pd.to_datetime(
                df["Arrival_Date"],
                errors="coerce"
            )

            print("\nDate coverage:")

            print(
                f"From: {dates.min().date()}"
            )

            print(
                f"To:   {dates.max().date()}"
            )

            print(
                f"Unique dates: "
                f"{dates.nunique()}"
            )

        # ----------------------------------------------------
        # Market information
        # ----------------------------------------------------

        if "Market" in df.columns:

            print(
                "\nUnique markets:",
                df["Market"].nunique()
            )

            print(
                "Top markets:"
            )

            print(
                df["Market"]
                .value_counts()
                .head(5)
                .to_string()
            )

        # ----------------------------------------------------
        # District information
        # ----------------------------------------------------

        if "District" in df.columns:

            print(
                "\nUnique districts:",
                df["District"].nunique()
            )

        # ----------------------------------------------------
        # Variety information
        # ----------------------------------------------------

        if "Variety" in df.columns:

            print(
                "Unique varieties:",
                df["Variety"].nunique()
            )

            print(
                "Top varieties:"
            )

            print(
                df["Variety"]
                .value_counts()
                .head(5)
                .to_string()
            )

        # ----------------------------------------------------
        # Price statistics
        # ----------------------------------------------------

        if "Modal_Price" in df.columns:

            prices = pd.to_numeric(
                df["Modal_Price"],
                errors="coerce"
            )

            print(
                "\nModal price:"
            )

            print(
                f"Minimum: {prices.min():.2f}"
            )

            print(
                f"Maximum: {prices.max():.2f}"
            )

            print(
                f"Average: {prices.mean():.2f}"
            )

            print(
                f"Median: {prices.median():.2f}"
            )

        # ----------------------------------------------------
        # Missing values
        # ----------------------------------------------------

        missing = df.isna().sum()

        missing_total = missing.sum()

        print(
            "\nTotal missing values:",
            missing_total
        )

        if missing_total > 0:

            print(
                missing[
                    missing > 0
                ].to_string()
            )

        # ----------------------------------------------------
        # Duplicate rows
        # ----------------------------------------------------

        duplicates = df.duplicated().sum()

        print(
            "Duplicate rows:",
            duplicates
        )

    except Exception as e:

        print(
            "❌ Error:"
        )

        print(e)


print("\n" + "=" * 70)
print("PROCESSED DATA INSPECTION COMPLETE")
print("=" * 70)