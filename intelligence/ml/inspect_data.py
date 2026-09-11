from pathlib import Path
import pandas as pd


# ============================================================
# FARMORA - DATA INSPECTION
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent

RAW_DIR = BASE_DIR / "data" / "raw"


CROPS = [
    "cotton",
    "rice",
    "sugarcane",
    "wheat",
    "onion",
    "tomato",
]


print("\n" + "=" * 70)
print("FARMORA - MARKET DATA INSPECTION")
print("=" * 70)

print(f"Raw data folder: {RAW_DIR}")

for crop in CROPS:

    file_path = RAW_DIR / f"{crop}_maharashtra.csv"

    print("\n" + "-" * 70)
    print(f"CROP: {crop.upper()}")
    print("-" * 70)

    if not file_path.exists():

        print("❌ File not found:")
        print(file_path)
        continue

    try:

        df = pd.read_csv(file_path)

        print(f"Rows: {len(df)}")
        print(f"Columns: {len(df.columns)}")

        print("\nColumns:")
        print(list(df.columns))

        print("\nFirst 3 records:")
        print(df.head(3).to_string(index=False))

        print("\nMissing values:")
        print(df.isnull().sum().to_string())

        if "Arrival_Date" in df.columns:

            dates = pd.to_datetime(
                df["Arrival_Date"],
                dayfirst=True,
                errors="coerce"
            )

            print("\nDate range:")

            if dates.notna().any():

                print(
                    f"From: {dates.min().date()}"
                )

                print(
                    f"To:   {dates.max().date()}"
                )

            else:

                print("No valid dates found.")

        if "Modal_Price" in df.columns:

            prices = pd.to_numeric(
                df["Modal_Price"],
                errors="coerce"
            )

            print("\nModal price statistics:")

            print(
                f"Minimum: {prices.min()}"
            )

            print(
                f"Maximum: {prices.max()}"
            )

            print(
                f"Average: {prices.mean():.2f}"
            )

    except Exception as e:

        print("❌ Error reading file:")
        print(e)


print("\n" + "=" * 70)
print("INSPECTION COMPLETE")
print("=" * 70)