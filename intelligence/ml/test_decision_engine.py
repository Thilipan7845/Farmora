from decision_engine import decide_sale


def test_case(title, **kwargs):

    print("\n" + "=" * 60)
    print(title)
    print("=" * 60)

    result = decide_sale(**kwargs)

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



# -------------------------------------------------
# TEST 1
# Cotton:
# Rising price + safe storage
# Expected:
# CONSIDER WAITING
# -------------------------------------------------

test_case(
    "TEST 1 - Cotton Rising Price + Good Storage",

    crop="cotton",

    prediction_horizon_days=14,

    current_price=7000,
    predicted_price=7500,

    storage_available=True,
    storage_cost="LOW",

    demand_level="HIGH",
    quantity=500
)



# -------------------------------------------------
# TEST 2
# Tomato:
# Falling price + no storage
# Expected:
# SELL NOW
# -------------------------------------------------

test_case(
    "TEST 2 - Tomato Falling Price + No Storage",

    crop="tomato",

    prediction_horizon_days=3,

    current_price=7500,
    predicted_price=7000,

    storage_available=False,
    storage_cost="HIGH",

    demand_level="LOW",
    quantity=500
)



# -------------------------------------------------
# TEST 3
# Onion:
# Stable price + large quantity
# Expected:
# PARTIAL SELL
# -------------------------------------------------

test_case(
    "TEST 3 - Onion Stable Price + Large Quantity",

    crop="onion",

    prediction_horizon_days=5,

    current_price=7200,
    predicted_price=7300,

    storage_available=True,
    storage_cost="LOW",

    demand_level="MEDIUM",
    quantity=2000
)



# -------------------------------------------------
# TEST 4
# Rice:
# Stable price + small quantity
# Expected:
# SELL NOW
# -------------------------------------------------

test_case(
    "TEST 4 - Rice Stable Price + Small Quantity",

    crop="rice",

    prediction_horizon_days=14,

    current_price=7200,
    predicted_price=7250,

    storage_available=False,
    storage_cost="HIGH",

    demand_level="LOW",
    quantity=300
)



# -------------------------------------------------
# TEST 5
# Tomato:
# Rising price but waiting exceeds shelf life
#
# Tomato shelf life = 7 days
# Prediction horizon = 14 days
#
# Expected:
# SELL NOW
# -------------------------------------------------

test_case(
    "TEST 5 - Tomato Rising But Shelf Life Risk",

    crop="tomato",

    prediction_horizon_days=14,

    current_price=7000,
    predicted_price=7500,

    storage_available=True,
    storage_cost="LOW",

    demand_level="HIGH",
    quantity=500
)