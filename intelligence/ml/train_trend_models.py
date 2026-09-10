import pandas as pd
import os
import joblib

from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import (
    accuracy_score,
    precision_score,
    recall_score,
    f1_score,
    confusion_matrix,
    classification_report
)


# -----------------------------
# Configuration
# -----------------------------

crops = [
    "cotton",
    "rice",
    "sugarcane",
    "wheat",
    "onion",
    "tomato"
]


feature_columns = [
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


model_dir = "intelligence/models"

os.makedirs(model_dir, exist_ok=True)


results = []


# -----------------------------
# Train each crop
# -----------------------------

for crop in crops:

    print("\n======================")
    print("Training:", crop)
    print("======================")


    file_path = f"intelligence/data/processed/{crop}_features.csv"


    if not os.path.exists(file_path):
        print("File missing:", file_path)
        continue


    df = pd.read_csv(file_path)


    # Create labels if not available

    df = df.dropna(
        subset=["Actual_Future_Change_Pct"]
    )


    def create_trend(change):

        if change > 2:
            return "RISING"

        elif change < -2:
            return "FALLING"

        else:
            return "STABLE"


    df["Trend_Label"] = (
        df["Actual_Future_Change_Pct"]
        .apply(create_trend)
    )


    # remove missing feature rows

    df = df.dropna(
        subset=feature_columns
    )


    # chronological ordering

    df["Arrival_Date"] = pd.to_datetime(
        df["Arrival_Date"]
    )

    df = df.sort_values(
        "Arrival_Date"
    )


    X = df[feature_columns]

    y = df["Trend_Label"]


    # 80/20 time split

    split = int(len(df) * 0.8)


    X_train = X.iloc[:split]
    X_test = X.iloc[split:]

    y_train = y.iloc[:split]
    y_test = y.iloc[split:]


    # Model

    model = RandomForestClassifier(
        n_estimators=200,
        random_state=42,
        class_weight="balanced"
    )


    model.fit(
        X_train,
        y_train
    )


    predictions = model.predict(
        X_test
    )


    # Evaluation

    accuracy = accuracy_score(
        y_test,
        predictions
    )

    precision = precision_score(
        y_test,
        predictions,
        average="weighted",
        zero_division=0
    )

    recall = recall_score(
        y_test,
        predictions,
        average="weighted",
        zero_division=0
    )

    f1 = f1_score(
        y_test,
        predictions,
        average="weighted",
        zero_division=0
    )


    print("\nResults")

    print("Accuracy :", accuracy)
    print("Precision:", precision)
    print("Recall   :", recall)
    print("F1 Score :", f1)


    print("\nClassification Report")

    print(
        classification_report(
            y_test,
            predictions,
            zero_division=0
        )
    )


    print("\nConfusion Matrix")

    print(
        confusion_matrix(
            y_test,
            predictions
        )
    )


    # Save model

    model_path = (
        f"{model_dir}/{crop}_trend_model.pkl"
    )


    joblib.dump(
        model,
        model_path
    )


    print(
        "Saved:",
        model_path
    )


    results.append(
        {
            "crop": crop,
            "accuracy": accuracy,
            "precision": precision,
            "recall": recall,
            "f1": f1
        }
    )


# Save summary

results_df = pd.DataFrame(results)

results_df.to_csv(
    "intelligence/models/trend_results.csv",
    index=False
)


print("\nFinal Results")
print(results_df)