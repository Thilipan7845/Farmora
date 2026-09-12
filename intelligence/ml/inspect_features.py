import pandas as pd

file_path = "intelligence/data/processed/cotton_features.csv"

df = pd.read_csv(file_path)

print("\nShape:")
print(df.shape)

print("\nColumns:")
for col in df.columns:
    print(col)

print("\nFirst 5 rows:")
print(df.head())

print("\nData types:")
print(df.dtypes)

print("\nMissing values:")
print(df.isnull().sum())