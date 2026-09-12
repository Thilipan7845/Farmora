from pathlib import Path
import sys

import pandas as pd


# ============================================================
# PYTHON PATH
# ============================================================

BACKEND_DIR = Path(__file__).resolve().parents[1]

if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))


from app.database.supabase_client import supabase


# ============================================================
# CONFIGURATION
# ============================================================

PROJECT_ROOT = BACKEND_DIR.parent

RAW_FILE = (
    PROJECT_ROOT
    / "intelligence"
    / "data"
    / "raw"
    / "cotton_maharashtra.csv"
)

CROP = "Cotton"
MARKET = "Parbhani"
VARIETY = "Other"
GRADE = "FAQ"


# ============================================================
# LOAD RAW DATA
# ============================================================

def load_source_data():

    if not RAW_FILE.exists():
        raise FileNotFoundError(
            f"Raw market data file not found: {RAW_FILE}"
        )

    df = pd.read_csv(RAW_FILE)

    required_columns = [
        "Arrival_Date",
        "Commodity",
        "District",
        "Grade",
        "Market",
        "Max_Price",
        "Min_Price",
        "Modal_Price",
        "State",
        "Variety",
    ]

    missing_columns = [
        column
        for column in required_columns
        if column not in df.columns
    ]

    if missing_columns:
        raise ValueError(
            f"Missing required columns: {missing_columns}"
        )

    return df


# ============================================================
# FILTER COTTON SERIES
# ============================================================

def prepare_series(df):

    filtered = df[
        (df["Commodity"] == CROP)
        & (df["Market"] == MARKET)
        & (df["Variety"] == VARIETY)
        & (df["Grade"] == GRADE)
    ].copy()

    if filtered.empty:
        raise ValueError(
            "No matching historical market series found."
        )

    # --------------------------------------------------------
    # CLEAN DATE
    # --------------------------------------------------------

    filtered["Arrival_Date"] = pd.to_datetime(
        filtered["Arrival_Date"],
        errors="coerce",
    )

    # --------------------------------------------------------
    # CLEAN PRICES
    # --------------------------------------------------------

    for column in [
        "Min_Price",
        "Max_Price",
        "Modal_Price",
    ]:
        filtered[column] = pd.to_numeric(
            filtered[column],
            errors="coerce",
        )

    # --------------------------------------------------------
    # REMOVE INVALID ROWS
    # --------------------------------------------------------

    filtered = filtered.dropna(
        subset=[
            "Arrival_Date",
            "Modal_Price",
        ]
    )

    # --------------------------------------------------------
    # SORT BY DATE
    # --------------------------------------------------------

    filtered = filtered.sort_values(
        "Arrival_Date"
    )

    # --------------------------------------------------------
    # REMOVE DUPLICATE DATES
    # --------------------------------------------------------

    filtered = (
        filtered
        .drop_duplicates(
            subset=["Arrival_Date"],
            keep="last",
        )
        .reset_index(drop=True)
    )

    return filtered


# ============================================================
# CHECK EXISTING SUPABASE RECORDS
# ============================================================

def get_existing_dates():

    result = (
        supabase
        .table("market_prices")
        .select("price_date")
        .eq("crop_name", CROP)
        .eq("market_name", MARKET)
        .eq("variety", VARIETY)
        .eq("grade", GRADE)
        .execute()
    )

    return {
        row["price_date"]
        for row in result.data
    }


# ============================================================
# IMPORT TO SUPABASE
# ============================================================

def import_series():

    print("=" * 70)
    print("FARMORA MARKET HISTORY IMPORT")
    print("=" * 70)

    print(f"\nSource file:")
    print(RAW_FILE)

    print("\nSeries:")
    print(f"Crop     : {CROP}")
    print(f"Market   : {MARKET}")
    print(f"Variety  : {VARIETY}")
    print(f"Grade    : {GRADE}")

    # --------------------------------------------------------
    # LOAD DATA
    # --------------------------------------------------------

    df = load_source_data()

    print(
        f"\nTotal rows in source file: {len(df)}"
    )

    # --------------------------------------------------------
    # PREPARE SERIES
    # --------------------------------------------------------

    series = prepare_series(df)

    print(
        f"Matching historical records: {len(series)}"
    )

    if series.empty:
        print("Nothing to import.")
        return

    # --------------------------------------------------------
    # EXISTING RECORDS
    # --------------------------------------------------------

    existing_dates = get_existing_dates()

    print(
        f"Existing Supabase records for this series: "
        f"{len(existing_dates)}"
    )

    # --------------------------------------------------------
    # CREATE INSERT DATA
    # --------------------------------------------------------

    records_to_insert = []

    for _, row in series.iterrows():

        price_date = (
            row["Arrival_Date"]
            .date()
            .isoformat()
        )

        if price_date in existing_dates:
            continue

        records_to_insert.append(
            {
                "crop_name": str(row["Commodity"]),
                "market_name": str(row["Market"]),
                "district": (
                    str(row["District"])
                    if pd.notna(row["District"])
                    else None
                ),
                "state": (
                    str(row["State"])
                    if pd.notna(row["State"])
                    else None
                ),
                "variety": (
                    str(row["Variety"])
                    if pd.notna(row["Variety"])
                    else None
                ),
                "grade": (
                    str(row["Grade"])
                    if pd.notna(row["Grade"])
                    else None
                ),
                "min_price": (
                    float(row["Min_Price"])
                    if pd.notna(row["Min_Price"])
                    else None
                ),
                "max_price": (
                    float(row["Max_Price"])
                    if pd.notna(row["Max_Price"])
                    else None
                ),
                "modal_price": float(
                    row["Modal_Price"]
                ),
                "price_date": price_date,
            }
        )

    # --------------------------------------------------------
    # NOTHING NEW
    # --------------------------------------------------------

    if not records_to_insert:

        print(
            "\nAll historical records are already "
            "present in Supabase."
        )

        return

    # --------------------------------------------------------
    # INSERT IN BATCHES
    # --------------------------------------------------------

    batch_size = 100

    inserted_count = 0

    for start in range(
        0,
        len(records_to_insert),
        batch_size,
    ):

        batch = records_to_insert[
            start:start + batch_size
        ]

        result = (
            supabase
            .table("market_prices")
            .insert(batch)
            .execute()
        )

        inserted_count += len(result.data)

        print(
            f"Inserted {len(result.data)} records..."
        )

    # --------------------------------------------------------
    # FINAL RESULT
    # --------------------------------------------------------

    print("\n" + "=" * 70)

    print(
        f"Successfully imported: "
        f"{inserted_count} historical records"
    )

    print(
        f"Total series records available: "
        f"{len(series)}"
    )

    print("=" * 70)


# ============================================================
# MAIN
# ============================================================

if __name__ == "__main__":
    import_series()