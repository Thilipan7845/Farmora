def decide_sale(
    current_price,
    predicted_price,
    storage_available,
    storage_cost,
    demand_level,
    quantity
):

    change_percent = (
        (predicted_price - current_price)
        / current_price
    ) * 100


    # Trend

    if change_percent > 2:
        trend = "RISING"

    elif change_percent < -2:
        trend = "FALLING"

    else:
        trend = "STABLE"



    reasons = []



    # Decision rules

    if (
        trend == "FALLING"
        and (
            not storage_available
            or storage_cost == "HIGH"
        )
    ):

        recommendation = "SELL NOW"

        reasons.append(
            "Expected price decrease"
        )


    elif (
        trend == "RISING"
        and storage_available
        and storage_cost == "LOW"
    ):

        recommendation = "CONSIDER WAITING"

        reasons.append(
            "Expected price increase"
        )

        reasons.append(
            "Storage condition supports waiting"
        )


    elif quantity > 1000:

        recommendation = "PARTIAL SELL"

        reasons.append(
            "Large quantity risk management"
        )


    else:

        recommendation = "SELL NOW"

        reasons.append(
            "No strong advantage in waiting"
        )



    return {

        "current_price": current_price,

        "predicted_price": predicted_price,

        "expected_change_percent":
            float(round(change_percent,2)),

        "trend": trend,

        "recommendation":
            recommendation,

        "reasons":
            reasons

    }