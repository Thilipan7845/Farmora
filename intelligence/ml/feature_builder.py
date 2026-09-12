import pandas as pd


# ============================================================
# FARMORA - LIVE FEATURE BUILDER
# ============================================================

def build_features(
    crop,
    market,
    variety,
    grade,
    history
):

    """
    Converts raw market history into the
    33 ML features required by farmora_predict.py

    Input:
        history = [
            {
                Arrival_Date,
                Min_Price,
                Max_Price,
                Modal_Price
            }
        ]

    Output:
        Single feature dictionary
    """

    # --------------------------------------------------------
    # Convert input to dataframe
    # --------------------------------------------------------

    df = pd.DataFrame(history)


    if len(df) < 30:

        raise Exception(
            "Minimum 30 historical price records required"
        )


    # --------------------------------------------------------
    # Prepare data
    # --------------------------------------------------------

    df["Arrival_Date"] = pd.to_datetime(
        df["Arrival_Date"]
    )


    df["Modal_Price"] = pd.to_numeric(
        df["Modal_Price"]
    )


    df["Min_Price"] = pd.to_numeric(
        df["Min_Price"]
    )


    df["Max_Price"] = pd.to_numeric(
        df["Max_Price"]
    )


    df["Market"] = market
    df["Variety"] = variety
    df["Grade"] = grade


    # Sort like training pipeline

    df = df.sort_values(
        "Arrival_Date"
    ).reset_index(drop=True)



    # --------------------------------------------------------
    # Basic price features
    # --------------------------------------------------------

    df["Price_Range"] = (
        df["Max_Price"]
        -
        df["Min_Price"]
    )


    df["Modal_Position"] = (

        (
            df["Modal_Price"]
            -
            df["Min_Price"]
        )

        /

        (
            df["Max_Price"]
            -
            df["Min_Price"]
        ).replace(0, 1)

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
        df["Arrival_Date"]
        .dt.isocalendar()
        .week
        .astype(int)
    )


    df["Day_Of_Week"] = (
        df["Arrival_Date"]
        .dt.dayofweek
    )


    df["Quarter"] = (
        df["Arrival_Date"]
        .dt.quarter
    )



    # --------------------------------------------------------
    # Lag Features
    # --------------------------------------------------------

    for lag in [
        1,
        2,
        3,
        5,
        7,
        14,
        30
    ]:

        df[f"Lag_{lag}"] = (
            df["Modal_Price"]
            .shift(lag)
        )



    # --------------------------------------------------------
    # Rolling Features
    # --------------------------------------------------------

    df["Rolling_Mean_3"] = (
        df["Modal_Price"]
        .shift(1)
        .rolling(3)
        .mean()
    )


    df["Rolling_Mean_7"] = (
        df["Modal_Price"]
        .shift(1)
        .rolling(7)
        .mean()
    )


    df["Rolling_Mean_14"] = (
        df["Modal_Price"]
        .shift(1)
        .rolling(14)
        .mean()
    )


    df["Rolling_Mean_30"] = (
        df["Modal_Price"]
        .shift(1)
        .rolling(30)
        .mean()
    )


    df["Rolling_Std_7"] = (
        df["Modal_Price"]
        .shift(1)
        .rolling(7)
        .std()
    )


    df["Rolling_Std_14"] = (
        df["Modal_Price"]
        .shift(1)
        .rolling(14)
        .std()
    )



    # --------------------------------------------------------
    # Price Changes
    # --------------------------------------------------------

    df["Price_Change_1"] = (
        df["Modal_Price"]
        -
        df["Lag_1"]
    )


    df["Price_Change_3"] = (
        df["Modal_Price"]
        -
        df["Lag_3"]
    )


    df["Price_Change_7"] = (
        df["Modal_Price"]
        -
        df["Lag_7"]
    )


    df["Price_Change_14"] = (
        df["Modal_Price"]
        -
        df["Lag_14"]
    )



    # --------------------------------------------------------
    # Percentage Changes
    # --------------------------------------------------------

    df["Price_Change_Pct_1"] = (

        df["Price_Change_1"]
        /
        df["Lag_1"]

    ) * 100


    df["Price_Change_Pct_7"] = (

        df["Price_Change_7"]
        /
        df["Lag_7"]

    ) * 100


    df["Price_Change_Pct_14"] = (

        df["Price_Change_14"]
        /
        df["Lag_14"]

    ) * 100



    # --------------------------------------------------------
    # Select latest row
    # --------------------------------------------------------

    latest = df.iloc[-1]



    FEATURES = [

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
        "Grade"
    ]


    feature_data = {}


    for col in FEATURES:

        feature_data[col] = latest[col]


    return feature_data