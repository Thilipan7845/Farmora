from decision_engine import decide_sale


result = decide_sale(

    crop="tomato",

    prediction_horizon_days=14,

    current_price=7000,

    predicted_price=7500,

    storage_available=True,

    storage_cost="LOW",

    demand_level="HIGH",

    quantity=500
)


print("Crop:", result["crop"])
print("Current Price:", result["current_price"])
print("Predicted Price:", result["predicted_price"])
print("Change %:", result["expected_change_percent"])
print("Prediction Horizon:", result["prediction_horizon_days"])
print("Trend:", result["trend"])
print("Recommendation:", result["recommendation"])
print("Reasons:", result["reasons"])

print("\nCrop Profile:")
print(result["crop_profile"])