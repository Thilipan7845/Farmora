from pathlib import Path

import pandas as pd


# ------------------------------------------------------------
# PROJECT PATHS
# ------------------------------------------------------------

PROJECT_ROOT = Path(__file__).resolve().parents[2]

RAW_DIR = PROJECT_ROOT / "intelligence" / "data" / "raw"


CROPS = [
    "cotton",
    "rice",
    "wheat",
    "sugarcane",
    "onion",
    "tomato",
]


# ------------------------------------------------------------
# INSPECT ONE CROP
# ------------------------------------------------------------

def inspect_crop(crop: str):

    file_path = RAW_DIR / f"{crop}_maharashtra.csv"

    print("\n" + "=" * 70)
    print(f"CROP: {crop.upper()}")
    print("=" * 70)

    if not file_path.exists():
        print(f"File not found: {file_path}")
        return

    df = pd.read_csv(file_path)

    print(f"Total rows: {len(df)}")

    print("\nColumns:")
    print(list(df.columns))

    # --------------------------------------------------------
    # CLEAN DATE
    # --------------------------------------------------------

    df["Arrival_Date"] = pd.to_datetime(
        df["Arrival_Date"],
        errors="coerce",
    )

    # --------------------------------------------------------
    # GROUP BY MARKET + VARIETY + GRADE
    # --------------------------------------------------------

    grouped = (
        df.groupby(
            [
                "Market",
                "Variety",
                "Grade",
            ],
            dropna=False,
        )
        .agg(
            record_count=("Arrival_Date", "count"),
            first_date=("Arrival_Date", "min"),
            last_date=("Arrival_Date", "max"),
        )
        .sort_values(
            "record_count",
            ascending=False,
        )
    )

    print("\nTop historical market series:")
    print(grouped.head(15).to_string())

    # --------------------------------------------------------
    # SERIES WITH AT LEAST 31 RECORDS
    # --------------------------------------------------------

    ready = grouped[
        grouped["record_count"] >= 31
    ]

    print(
        f"\nSeries with at least 31 records: "
        f"{len(ready)}"
    )

    if not ready.empty:
        print("\nPrediction-ready historical series:")
        print(
            ready.head(15).to_string()
        )
    else:
        print(
            "No Market + Variety + Grade combination "
            "has 31 or more records."
        )

    # --------------------------------------------------------
    # NAGPUR-RELATED MARKETS
    # --------------------------------------------------------

    nagpur = df[
        df["Market"]
        .astype(str)
        .str.contains(
            "nagpur",
            case=False,
            na=False,
        )
    ]

    if not nagpur.empty:

        print("\nNagpur-related market records:")

        nagpur_groups = (
            nagpur.groupby(
                [
                    "Market",
                    "Variety",
                    "Grade",
                ],
                dropna=False,
            )
            .agg(
                record_count=("Arrival_Date", "count"),
                first_date=("Arrival_Date", "min"),
                last_date=("Arrival_Date", "max"),
            )
            .sort_values(
                "record_count",
                ascending=False,
            )
        )

        print(
            nagpur_groups.head(15).to_string()
        )


# ------------------------------------------------------------
# MAIN
# ------------------------------------------------------------

def main():

    print("=" * 70)
    print("FARMORA MARKET HISTORY INSPECTION")
    print("=" * 70)

    print(f"\nRaw data directory:")
    print(RAW_DIR)

    for crop in CROPS:
        inspect_crop(crop)

    print("\n" + "=" * 70)
    print("INSPECTION COMPLETE")
    print("=" * 70)


if __name__ == "__main__":
    main()