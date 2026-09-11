from farmora_predict import predict_market_decision



sample_input = {

    "Modal_Price": 7200,
    "Min_Price": 6800,
    "Max_Price": 7500,
    "Price_Range": 700,
    "Modal_Position": 0.5,


    "Year": 2026,
    "Month": 9,
    "Week_Of_Year": 37,
    "Day_Of_Week": 5,
    "Quarter": 3,


    "Lag_1": 7150,
    "Lag_2": 7100,
    "Lag_3": 7050,
    "Lag_5": 7000,
    "Lag_7": 6950,
    "Lag_14": 6900,
    "Lag_30": 6800,


    "Rolling_Mean_3": 7100,
    "Rolling_Mean_7": 7050,
    "Rolling_Mean_14": 7000,
    "Rolling_Mean_30": 6900,


    "Rolling_Std_7": 100,
    "Rolling_Std_14": 120,


    "Price_Change_1": 50,
    "Price_Change_3": 100,
    "Price_Change_7": 200,
    "Price_Change_14": 300,


    "Price_Change_Pct_1": 0.7,
    "Price_Change_Pct_7": 2.8,
    "Price_Change_Pct_14": 4.2,


    "Market": "Nagpur",
    "Variety": "H4",
    "Grade": "A"
}




result = predict_market_decision(

    crop="cotton",

    input_data=sample_input,


    # Storage information
    storage_available=True,

    storage_cost="LOW",


    # Market information
    demand_level="HIGH",


    # Farmer quantity
    quantity=2000,


    # Profit calculation inputs
    transport_cost=2000,

    storage_expense=500

)



print(result)