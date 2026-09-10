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
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score


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
    "tomato",
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
    "Price_Change_Pct_14",
]


CATEGORICAL_FEATURES = [
    "Market",
    "Variety",
    "Grade",
]


TARGET = "Target_Price"


# ============================================================
# TRAINING FUNCTION
# ============================================================

def train_crop(crop):

    print("\n" + "=" * 70)
    print(f"TRAINING: {crop.upper()}")
    print("=" * 70)

    input_file = (
        PROCESSED_DIR
        / f"{crop}_features.csv"
    )

    if not input_file.exists():

        print(
            "❌ File not found:"
        )

        print(input_file)

        return None

    # --------------------------------------------------------
    # Load dataset
    # --------------------------------------------------------

    df = pd.read_csv(
        input_file
    )

    print(
        f"Total rows loaded: {len(df)}"
    )

    # --------------------------------------------------------
    # Keep only rows having a future target
    # --------------------------------------------------------

    df = df.dropna(
        subset=[TARGET]
    ).copy()

    print(
        f"Rows with target: {len(df)}"
    )

    if len(df) < 50:

        print(
            "❌ Not enough rows for reliable training."
        )

        return None

    # --------------------------------------------------------
    # Sort chronologically
    # --------------------------------------------------------

    df["Arrival_Date"] = pd.to_datetime(
        df["Arrival_Date"],
        errors="coerce"
    )

    df = df.sort_values(
        "Arrival_Date"
    ).reset_index(
        drop=True
    )

    # --------------------------------------------------------
    # Check feature availability
    # --------------------------------------------------------

    available_numeric = [
        column
        for column in NUMERIC_FEATURES
        if column in df.columns
    ]

    available_categorical = [
        column
        for column in CATEGORICAL_FEATURES
        if column in df.columns
    ]

    feature_columns = (
        available_numeric
        + available_categorical
    )

    missing_features = [
        column
        for column in (
            NUMERIC_FEATURES
            + CATEGORICAL_FEATURES
        )
        if column not in df.columns
    ]

    if missing_features:

        print(
            "\nWarning - missing features:"
        )

        print(
            missing_features
        )

    print(
        f"\nFeatures used: "
        f"{len(feature_columns)}"
    )

    # --------------------------------------------------------
    # Remove rows where target is invalid
    # --------------------------------------------------------

    df[TARGET] = pd.to_numeric(
        df[TARGET],
        errors="coerce"
    )

    df = df.dropna(
        subset=[TARGET]
    ).copy()

    # --------------------------------------------------------
    # Chronological train/test split
    # --------------------------------------------------------
    #
    # First 80% = training
    # Last 20%  = testing
    #
    # No random split.
    #
    # --------------------------------------------------------

    split_index = int(
        len(df) * 0.80
    )

    train_df = df.iloc[
        :split_index
    ].copy()

    test_df = df.iloc[
        split_index:
    ].copy()

    print(
        f"\nTraining rows: "
        f"{len(train_df)}"
    )

    print(
        f"Testing rows: "
        f"{len(test_df)}"
    )

    print(
        f"Training period: "
        f"{train_df['Arrival_Date'].min().date()} "
        f"to "
        f"{train_df['Arrival_Date'].max().date()}"
    )

    print(
        f"Testing period: "
        f"{test_df['Arrival_Date'].min().date()} "
        f"to "
        f"{test_df['Arrival_Date'].max().date()}"
    )

    # --------------------------------------------------------
    # X and y
    # --------------------------------------------------------

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

    # --------------------------------------------------------
    # Preprocessing
    # --------------------------------------------------------

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

    print("\nTraining Linear Regression...")

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

    linear_predictions = (
        linear_model.predict(
            X_test
        )
    )

    linear_mae = mean_absolute_error(
        y_test,
        linear_predictions
    )

    linear_rmse = mean_squared_error(
        y_test,
        linear_predictions
    ) ** 0.5

    linear_r2 = r2_score(
        y_test,
        linear_predictions
    )

    print(
        f"Linear MAE:  {linear_mae:.2f}"
    )

    print(
        f"Linear RMSE: {linear_rmse:.2f}"
    )

    print(
        f"Linear R²:   {linear_r2:.4f}"
    )

    # ========================================================
    # MODEL 2 - RANDOM FOREST
    # ========================================================

    print("\nTraining Random Forest...")

    rf_preprocessor = ColumnTransformer(
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

    rf_model = Pipeline(
        steps=[
            (
                "preprocessor",
                rf_preprocessor
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

    rf_predictions = (
        rf_model.predict(
            X_test
        )
    )

    rf_mae = mean_absolute_error(
        y_test,
        rf_predictions
    )

    rf_rmse = mean_squared_error(
        y_test,
        rf_predictions
    ) ** 0.5

    rf_r2 = r2_score(
        y_test,
        rf_predictions
    )

    print(
        f"Random Forest MAE:  "
        f"{rf_mae:.2f}"
    )

    print(
        f"Random Forest RMSE: "
        f"{rf_rmse:.2f}"
    )

    print(
        f"Random Forest R²:   "
        f"{rf_r2:.4f}"
    )

    # ========================================================
    # SELECT BEST MODEL
    # ========================================================
    #
    # Lower MAE is better.
    #
    # ========================================================

    if rf_mae < linear_mae:

        best_model = rf_model

        best_model_name = (
            "Random Forest"
        )

        best_mae = rf_mae

        best_rmse = rf_rmse

        best_r2 = rf_r2

    else:

        best_model = linear_model

        best_model_name = (
            "Linear Regression"
        )

        best_mae = linear_mae

        best_rmse = linear_rmse

        best_r2 = linear_r2

    print(
        f"\nBEST MODEL: "
        f"{best_model_name}"
    )

    print(
        f"Best MAE:  {best_mae:.2f}"
    )

    print(
        f"Best RMSE: {best_rmse:.2f}"
    )

    print(
        f"Best R²:   {best_r2:.4f}"
    )

    # ========================================================
    # SAVE MODEL
    # ========================================================

    model_file = (
        MODEL_DIR
        / f"{crop}_price_model.joblib"
    )

    joblib.dump(
        best_model,
        model_file
    )

    print(
        f"\nModel saved:"
    )

    print(
        model_file
    )

    # ========================================================
    # SAVE METRICS
    # ========================================================

    metrics = {
        "crop": crop,
        "rows_total": int(len(df)),
        "rows_train": int(len(train_df)),
        "rows_test": int(len(test_df)),

        "linear_regression": {
            "MAE": float(linear_mae),
            "RMSE": float(linear_rmse),
            "R2": float(linear_r2),
        },

        "random_forest": {
            "MAE": float(rf_mae),
            "RMSE": float(rf_rmse),
            "R2": float(rf_r2),
        },

        "best_model": best_model_name,

        "best_model_metrics": {
            "MAE": float(best_mae),
            "RMSE": float(best_rmse),
            "R2": float(best_r2),
        },

        "features": feature_columns,
    }

    metrics_file = (
        MODEL_DIR
        / f"{crop}_metrics.json"
    )

    with open(
        metrics_file,
        "w",
        encoding="utf-8"
    ) as file:

        json.dump(
            metrics,
            file,
            indent=4
        )

    print(
        f"Metrics saved:"
    )

    print(
        metrics_file
    )

    return metrics


# ============================================================
# MAIN
# ============================================================

def main():

    print("\n")
    print("=" * 70)
    print("FARMORA - ML MODEL TRAINING")
    print("=" * 70)

    results = []

    for crop in CROPS:

        result = train_crop(
            crop
        )

        if result is not None:

            results.append(
                result
            )

    # ========================================================
    # FINAL SUMMARY
    # ========================================================

    print("\n")
    print("=" * 70)
    print("TRAINING COMPLETE")
    print("=" * 70)

    if results:

        print(
            "\nMODEL SUMMARY"
        )

        print(
            "-" * 70
        )

        for result in results:

            metrics = (
                result["best_model_metrics"]
            )

            print(
                f"{result['crop'].upper():12}"
                f" | "
                f"{result['best_model']:18}"
                f" | MAE: "
                f"{metrics['MAE']:.2f}"
                f" | RMSE: "
                f"{metrics['RMSE']:.2f}"
                f" | R²: "
                f"{metrics['R2']:.4f}"
            )

    print(
        "\nModels saved in:"
    )

    print(
        MODEL_DIR
    )

    print("=" * 70)


# ============================================================
# RUN
# ============================================================

if __name__ == "__main__":
    main()