from typing import Any

import pandas as pd

from app.database.supabase_client import supabase


FEATURE_COLUMNS = [
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
    "Market",
    "Variety",
    "Grade",
]


def build_market_features(
    crop: str,
    market: str,
    variety: str | None = None,
    grade: str | None = None,
) -> dict[str, Any]:

    # ------------------------------------------------------------
    # GET MARKET PRICE HISTORY
    # ------------------------------------------------------------

    result = (
        supabase.table("market_prices")
        .select("*")
        .eq("crop_name", crop)
        .eq("market_name", market)
        .order("price_date", desc=False)
        .execute()
    )

    rows = result.data

    if not rows:
        raise ValueError(
            f"No market price history found for crop '{crop}' "
            f"and market '{market}'."
        )

    # ------------------------------------------------------------
    # CREATE DATAFRAME
    # ------------------------------------------------------------

    df = pd.DataFrame(rows)

    df["price_date"] = pd.to_datetime(
        df["price_date"],
        errors="coerce",
    )

    for column in [
        "min_price",
        "max_price",
        "modal_price",
    ]:
        df[column] = pd.to_numeric(
            df[column],
            errors="coerce",
        )

    # Remove invalid records
    df = df.dropna(
        subset=[
            "price_date",
            "modal_price",
        ]
    ).copy()

    if df.empty:
        raise ValueError(
            "No valid market price records available."
        )

    # ------------------------------------------------------------
    # FILTER VARIETY
    # ------------------------------------------------------------

    if variety is not None:
        df = df[df["variety"] == variety]

    # ------------------------------------------------------------
    # FILTER GRADE
    # ------------------------------------------------------------

    if grade is not None:
        df = df[df["grade"] == grade]

    if df.empty:
        raise ValueError(
            "No market history found for the requested "
            "crop, market, variety and grade."
        )

    # ------------------------------------------------------------
    # SORT HISTORY
    # ------------------------------------------------------------

    df = (
        df.sort_values("price_date")
        .reset_index(drop=True)
    )

    latest = df.iloc[-1]

    prices = df["modal_price"]

    # ------------------------------------------------------------
    # BASIC PRICE FEATURES
    # ------------------------------------------------------------

    modal_price = float(latest["modal_price"])

    if pd.notna(latest["min_price"]):
        min_price = float(latest["min_price"])
    else:
        min_price = modal_price

    if pd.notna(latest["max_price"]):
        max_price = float(latest["max_price"])
    else:
        max_price = modal_price

    price_range = max_price - min_price

    if price_range == 0:
        modal_position = 0.0
    else:
        modal_position = (
            (modal_price - min_price)
            / price_range
        )

    # ------------------------------------------------------------
    # INITIAL FEATURES
    # ------------------------------------------------------------

    features = {
        "Modal_Price": modal_price,
        "Min_Price": min_price,
        "Max_Price": max_price,
        "Price_Range": price_range,
        "Modal_Position": modal_position,

        "Year": int(latest["price_date"].year),
        "Month": int(latest["price_date"].month),
        "Week_Of_Year": int(
            latest["price_date"].isocalendar().week
        ),
        "Day_Of_Week": int(
            latest["price_date"].dayofweek
        ),
        "Quarter": int(
            latest["price_date"].quarter
        ),

        "Market": market,

        "Variety": (
            variety
            if variety is not None
            else latest.get("variety")
        ),

        "Grade": (
            grade
            if grade is not None
            else latest.get("grade")
        ),
    }

    # ------------------------------------------------------------
    # LAG FEATURES
    # ------------------------------------------------------------

    lag_values = {
        1: "Lag_1",
        2: "Lag_2",
        3: "Lag_3",
        5: "Lag_5",
        7: "Lag_7",
        14: "Lag_14",
        30: "Lag_30",
    }

    for lag, feature_name in lag_values.items():

        if len(prices) > lag:

            features[feature_name] = float(
                prices.iloc[-lag - 1]
            )

        else:

            features[feature_name] = None

    # ------------------------------------------------------------
    # ROLLING MEAN FEATURES
    # ------------------------------------------------------------

    historical_prices = prices.iloc[:-1]

    rolling_windows = {
        3: "Rolling_Mean_3",
        7: "Rolling_Mean_7",
        14: "Rolling_Mean_14",
        30: "Rolling_Mean_30",
    }

    for window, feature_name in rolling_windows.items():

        if len(historical_prices) >= window:

            features[feature_name] = float(
                historical_prices
                .tail(window)
                .mean()
            )

        else:

            features[feature_name] = None

    # ------------------------------------------------------------
    # ROLLING STANDARD DEVIATION FEATURES
    # ------------------------------------------------------------

    rolling_std_windows = {
        7: "Rolling_Std_7",
        14: "Rolling_Std_14",
    }

    for window, feature_name in rolling_std_windows.items():

        if len(historical_prices) >= window:

            features[feature_name] = float(
                historical_prices
                .tail(window)
                .std()
            )

        else:

            features[feature_name] = None

    # ------------------------------------------------------------
    # PRICE CHANGE FEATURES
    # ------------------------------------------------------------

    change_lags = {
        1: "Price_Change_1",
        3: "Price_Change_3",
        7: "Price_Change_7",
        14: "Price_Change_14",
    }

    for lag, feature_name in change_lags.items():

        if len(prices) > lag:

            previous_price = float(
                prices.iloc[-lag - 1]
            )

            features[feature_name] = (
                modal_price - previous_price
            )

        else:

            features[feature_name] = None

    # ------------------------------------------------------------
    # PRICE CHANGE PERCENTAGE FEATURES
    # ------------------------------------------------------------

    percentage_changes = {
        1: "Price_Change_Pct_1",
        7: "Price_Change_Pct_7",
        14: "Price_Change_Pct_14",
    }

    for lag, feature_name in percentage_changes.items():

        if len(prices) > lag:

            previous_price = float(
                prices.iloc[-lag - 1]
            )

            if previous_price == 0:

                features[feature_name] = None

            else:

                features[feature_name] = (
                    (
                        modal_price
                        - previous_price
                    )
                    / previous_price
                ) * 100

        else:

            features[feature_name] = None

    # ------------------------------------------------------------
    # RETURN EXACT ML FEATURE STRUCTURE
    # ------------------------------------------------------------

    return {
        "features": {
            column: features.get(column)
            for column in FEATURE_COLUMNS
        },
        "record_count": len(df),
        "latest_price_date": (
            latest["price_date"]
            .date()
            .isoformat()
        ),
        "prediction_ready": len(df) >= 31,
    }