import pandas as pd
import os
import joblib

from sklearn.ensemble import RandomForestClassifier
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder
from sklearn.pipeline import Pipeline

from sklearn.metrics import (
    accuracy_score,
    precision_score,
    recall_score,
    f1_score,
    classification_report
)


crops = [
    "cotton",
    "rice",
    "sugarcane",
    "wheat",
    "onion",
    "tomato"
]


numeric_features = [

    "Modal_Price",

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

    "Month",
    "Week_Of_Year",
    "Quarter"
]


categorical_features = [
    "District",
    "Market",
    "Variety",
    "Grade"
]


model_dir = "intelligence/models"

os.makedirs(
    model_dir,
    exist_ok=True
)


results = []


def create_trend(change):

    if change > 2:
        return "RISING"

    elif change < -2:
        return "FALLING"

    else:
        return "STABLE"



for crop in crops:

    print("\n======================")
    print("Training:", crop)
    print("======================")


    path = (
        f"intelligence/data/processed/{crop}_features.csv"
    )


    if not os.path.exists(path):
        print("Missing:", path)
        continue


    df = pd.read_csv(path)


    df = df.dropna(
        subset=["Actual_Future_Change_Pct"]
    )


    df["Trend_Label"] = (
        df["Actual_Future_Change_Pct"]
        .apply(create_trend)
    )


    all_features = (
        numeric_features +
        categorical_features
    )


    df = df.dropna(
        subset=all_features
    )


    df["Arrival_Date"] = pd.to_datetime(
        df["Arrival_Date"]
    )


    df = df.sort_values(
        "Arrival_Date"
    )


    X = df[all_features]

    y = df["Trend_Label"]


    split = int(
        len(df) * 0.8
    )


    X_train = X.iloc[:split]
    X_test = X.iloc[split:]

    y_train = y.iloc[:split]
    y_test = y.iloc[split:]


    preprocessor = ColumnTransformer(
        transformers=[
            (
                "num",
                "passthrough",
                numeric_features
            ),

            (
                "cat",
                OneHotEncoder(
                    handle_unknown="ignore"
                ),
                categorical_features
            )
        ]
    )


    model = RandomForestClassifier(
        n_estimators=300,
        random_state=42,
        class_weight="balanced"
    )


    pipeline = Pipeline(
        steps=[
            (
                "preprocessor",
                preprocessor
            ),

            (
                "classifier",
                model
            )
        ]
    )


    pipeline.fit(
        X_train,
        y_train
    )


    prediction = pipeline.predict(
        X_test
    )


    accuracy = accuracy_score(
        y_test,
        prediction
    )


    precision = precision_score(
        y_test,
        prediction,
        average="weighted",
        zero_division=0
    )


    recall = recall_score(
        y_test,
        prediction,
        average="weighted",
        zero_division=0
    )


    f1 = f1_score(
        y_test,
        prediction,
        average="weighted",
        zero_division=0
    )


    print("\nAccuracy:", accuracy)
    print("Precision:", precision)
    print("Recall:", recall)
    print("F1:", f1)


    print(
        classification_report(
            y_test,
            prediction,
            zero_division=0
        )
    )


    save_path = (
        f"{model_dir}/{crop}_trend_model_v2.pkl"
    )


    joblib.dump(
        pipeline,
        save_path
    )


    print(
        "Saved:",
        save_path
    )


    results.append(
        {
            "crop":crop,
            "accuracy":accuracy,
            "precision":precision,
            "recall":recall,
            "f1":f1
        }
    )



results_df = pd.DataFrame(results)


results_df.to_csv(
    "intelligence/models/trend_results_v2.csv",
    index=False
)


print("\nFinal Results")
print(results_df)