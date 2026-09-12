def calculate_profit(
    quantity,
    current_price,
    predicted_price,
    transport_cost,
    storage_cost
):


    # Current selling value

    current_revenue = (
        current_price * quantity
    )


    # Future selling value

    future_revenue = (
        predicted_price * quantity
    )


    # Total additional cost

    total_cost = (
        transport_cost
        +
        storage_cost
    )


    # Net values

    current_net = current_revenue


    future_net = (
        future_revenue
        -
        total_cost
    )


    profit_difference = (
        future_net
        -
        current_net
    )


    if profit_difference > 0:

        better_choice = "WAIT"


    else:

        better_choice = "SELL NOW"



    return {

    "current_net_realization": float(current_net),

    "future_net_realization": float(future_net),

    "profit_difference": float(profit_difference),

    "better_choice": better_choice

    }