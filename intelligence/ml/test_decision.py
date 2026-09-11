from intelligence.decision_engine import decide_sale


result = decide_sale(
    current_price=7000,
    predicted_price=7500,
    storage_available=True,
    storage_cost="LOW",
    demand_level="HIGH",
    quantity=500
)


print(result)