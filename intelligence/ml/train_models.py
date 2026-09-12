from pathlib import Path
import json

import joblib
import pandas as pd

from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder
from sklearn.impute import SimpleImputer

from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor

from xgboost import XGBRegressor

from sklearn.metrics import (
    mean_absolute_error,
    mean_squared_error,
    r2_score
)


# ============================================================
# FARMORA - MODEL TRAINING
# ============================================================


BASE_DIR = Path(__file__).resolve().parent.parent

PROCESSED_DIR = BASE_DIR / "data" / "processed"

MODEL_DIR = BASE_DIR / "models"

MODEL_DIR.mkdir(
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
    "tomato"
]



# ============================================================
# FEATURES
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
    "Price_Change_Pct_14"
]


CATEGORICAL_FEATURES = [

    "Market",
    "Variety",
    "Grade"

]


TARGET = "Target_Price"



# ============================================================
# TRAIN FUNCTION
# ============================================================


def train_crop(crop):


    print("\n" + "=" * 70)
    print(f"TRAINING: {crop.upper()}")
    print("=" * 70)



    input_file = (
        PROCESSED_DIR /
        f"{crop}_features.csv"
    )


    if not input_file.exists():

        print(
            "File not found:",
            input_file
        )

        return None



    df = pd.read_csv(
        input_file
    )


    print(
        "Total rows:",
        len(df)
    )



    df = df.dropna(
        subset=[TARGET]
    ).copy()



    df["Arrival_Date"] = pd.to_datetime(
        df["Arrival_Date"],
        errors="coerce"
    )


    df = df.sort_values(
        "Arrival_Date"
    ).reset_index(
        drop=True
    )



    available_numeric = [
        x for x in NUMERIC_FEATURES
        if x in df.columns
    ]


    available_categorical = [
        x for x in CATEGORICAL_FEATURES
        if x in df.columns
    ]


    feature_columns = (
        available_numeric
        +
        available_categorical
    )



    print(
        "Features used:",
        len(feature_columns)
    )



    split_index = int(
        len(df) * 0.8
    )


    train_df = df.iloc[:split_index]

    test_df = df.iloc[split_index:]



    X_train = train_df[
        feature_columns
    ]

    y_train = train_df[
        TARGET
    ]


    X_test = test_df[
        feature_columns
    ]

    y_test = test_df[
        TARGET
    ]



    # ========================================================
    # PREPROCESSING
    # ========================================================


    numeric_pipeline = Pipeline(
        steps=[

            (
                "imputer",
                SimpleImputer(
                    strategy="median"
                )
            )

        ]
    )


    categorical_pipeline = Pipeline(
        steps=[

            (
                "imputer",
                SimpleImputer(
                    strategy="most_frequent"
                )
            ),

            (
                "onehot",
                OneHotEncoder(
                    handle_unknown="ignore"
                )
            )

        ]
    )


    preprocessor = ColumnTransformer(
        transformers=[

            (
                "numeric",
                numeric_pipeline,
                available_numeric
            ),

            (
                "categorical",
                categorical_pipeline,
                available_categorical
            )

        ]
    )



    # ========================================================
    # MODEL 1 - LINEAR REGRESSION
    # ========================================================


    print(
        "\nTraining Linear Regression..."
    )


    linear_model = Pipeline(
        steps=[

            (
                "preprocessor",
                preprocessor
            ),

            (
                "model",
                LinearRegression()
            )

        ]
    )


    linear_model.fit(
        X_train,
        y_train
    )


    linear_pred = linear_model.predict(
        X_test
    )


    linear_mae = mean_absolute_error(
        y_test,
        linear_pred
    )


    linear_rmse = mean_squared_error(
        y_test,
        linear_pred
    ) ** 0.5


    linear_r2 = r2_score(
        y_test,
        linear_pred
    )



    print(
        "Linear MAE:",
        round(linear_mae,2)
    )



    # ========================================================
    # MODEL 2 - RANDOM FOREST
    # ========================================================


    print(
        "\nTraining Random Forest..."
    )


    rf_model = Pipeline(
        steps=[

            (
                "preprocessor",
                preprocessor
            ),

            (
                "model",

                RandomForestRegressor(

                    n_estimators=200,

                    max_depth=20,

                    min_samples_leaf=2,

                    random_state=42,

                    n_jobs=-1

                )
            )

        ]
    )


    rf_model.fit(
        X_train,
        y_train
    )


    rf_pred = rf_model.predict(
        X_test
    )


    rf_mae = mean_absolute_error(
        y_test,
        rf_pred
    )


    rf_rmse = mean_squared_error(
        y_test,
        rf_pred
    ) ** 0.5


    rf_r2 = r2_score(
        y_test,
        rf_pred
    )



    print(
        "Random Forest MAE:",
        round(rf_mae,2)
    )



    # ========================================================
    # MODEL 3 - XGBOOST
    # ========================================================


    print(
        "\nTraining XGBoost..."
    )


    xgb_model = Pipeline(
        steps=[

            (
                "preprocessor",
                preprocessor
            ),

            (
                "model",

                XGBRegressor(

                    n_estimators=300,

                    learning_rate=0.05,

                    max_depth=6,

                    subsample=0.8,

                    colsample_bytree=0.8,

                    random_state=42

                )

            )

        ]
    )


    xgb_model.fit(
        X_train,
        y_train
    )


    xgb_pred = xgb_model.predict(
        X_test
    )


    xgb_mae = mean_absolute_error(
        y_test,
        xgb_pred
    )


    xgb_rmse = mean_squared_error(
        y_test,
        xgb_pred
    ) ** 0.5


    xgb_r2 = r2_score(
        y_test,
        xgb_pred
    )



    print(
        "XGBoost MAE:",
        round(xgb_mae,2)
    )



    # ========================================================
    # MODEL SELECTION
    # ========================================================


    models = {


        "Linear Regression": {

            "model": linear_model,

            "MAE": linear_mae,

            "RMSE": linear_rmse,

            "R2": linear_r2

        },


        "Random Forest": {

            "model": rf_model,

            "MAE": rf_mae,

            "RMSE": rf_rmse,

            "R2": rf_r2

        },


        "XGBoost": {

            "model": xgb_model,

            "MAE": xgb_mae,

            "RMSE": xgb_rmse,

            "R2": xgb_r2

        }

    }



    best_model_name = min(
        models,
        key=lambda x: models[x]["MAE"]
    )


    best_model = models[
        best_model_name
    ]["model"]



    print(
        "\nBEST MODEL:",
        best_model_name
    )



    # ========================================================
    # SAVE MODEL
    # ========================================================


    model_file = (
        MODEL_DIR /
        f"{crop}_price_model.joblib"
    )


    joblib.dump(
        best_model,
        model_file
    )


    print(
        "Saved:",
        model_file
    )



    # ========================================================
    # SAVE METRICS
    # ========================================================


    metrics = {

        "crop": crop,

        "linear_regression": {

            "MAE": float(linear_mae),

            "RMSE": float(linear_rmse),

            "R2": float(linear_r2)

        },


        "random_forest": {

            "MAE": float(rf_mae),

            "RMSE": float(rf_rmse),

            "R2": float(rf_r2)

        },


        "xgboost": {

            "MAE": float(xgb_mae),

            "RMSE": float(xgb_rmse),

            "R2": float(xgb_r2)

        },


        "best_model":
            best_model_name

    }



    metrics_file = (
        MODEL_DIR /
        f"{crop}_metrics.json"
    )


    with open(
        metrics_file,
        "w"
    ) as f:

        json.dump(
            metrics,
            f,
            indent=4
        )


    return metrics




# ============================================================
# MAIN
# ============================================================


def main():

    results = []


    for crop in CROPS:

        result = train_crop(
            crop
        )

        if result:

            results.append(
                result
            )


    print("\nTRAINING COMPLETE")


    for r in results:

        print(
            r["crop"],
            "->",
            r["best_model"]
        )



if __name__ == "__main__":

    main()