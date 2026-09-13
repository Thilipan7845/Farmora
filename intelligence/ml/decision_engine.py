from .crop_profile import get_crop_profile



# ============================================================
# Quantity Strategy
# ============================================================

def calculate_quantity_strategy(
    quantity,
    trend,
    confidence_score,
    range_supports_waiting,
    storage_available,
    profit_difference
):


    # High profit opportunity
    # Store more quantity

    if (
        profit_difference > 100000
        and confidence_score >= 70
        and range_supports_waiting
        and storage_available
    ):

        sell_percentage = 0.40



    # Risk situation

    elif (
        trend == "FALLING"
        or confidence_score < 50
        or not storage_available
    ):

        sell_percentage = 0.90



    # Normal

    else:

        sell_percentage = 0.70



    sell_quantity = round(
        quantity * sell_percentage
    )


    store_quantity = (
        quantity - sell_quantity
    )


    return {

        "total_quantity": quantity,

        "sell_now_quantity": sell_quantity,

        "store_quantity": store_quantity,

        "sell_percentage":
            round(
                sell_percentage * 100,
                2
            ),

        "store_percentage":
            round(
                (1 - sell_percentage) * 100,
                2
            )
    }





# ============================================================
# Decision Engine
# ============================================================

def decide_sale(
    crop,
    prediction_horizon_days,
    current_price,
    predicted_price,
    expected_price_range,
    storage_available,
    storage_cost,
    demand_level,
    quantity,
    confidence_score,
    profit_analysis
):


    # --------------------------------------------------------
    # Price change
    # --------------------------------------------------------

    change_percent = (

        (predicted_price - current_price)

        /

        current_price

    ) * 100




    # --------------------------------------------------------
    # Trend
    # --------------------------------------------------------

    if change_percent > 2:

        trend = "RISING"


    elif change_percent < -2:

        trend = "FALLING"


    else:

        trend = "STABLE"





    # --------------------------------------------------------
    # Crop profile
    # --------------------------------------------------------

    crop_profile = get_crop_profile(crop)


    shelf_life_days = crop_profile[
        "shelf_life_days"
    ]


    storage_risk = crop_profile[
        "storage_risk"
    ]


    cold_storage_required = crop_profile[
        "cold_storage_required"
    ]



    waiting_risk = (

        prediction_horizon_days >

        shelf_life_days

    )





    # --------------------------------------------------------
    # Prediction intelligence
    # --------------------------------------------------------

    lower_price = expected_price_range[
        "lower"
    ]


    upper_price = expected_price_range[
        "upper"
    ]



    # Expected gain

    expected_gain = (

        predicted_price - current_price

    )



    # Price range opportunity

    range_supports_waiting = (

        expected_gain > 0

        or

        upper_price > current_price * 1.03

    )




    low_confidence = (

        confidence_score < 50

    )


    strong_confidence = (

        confidence_score >= 70

    )




    # --------------------------------------------------------
    # Profit intelligence
    # --------------------------------------------------------

    profit_difference = profit_analysis[

        "profit_difference"

    ]


    waiting_is_profitable = (

        profit_difference > 0

    )



    reasons = []

    quantity_strategy = None





    # ========================================================
    # FINAL DECISION
    # ========================================================


    # 1. Falling price

    if trend == "FALLING":


        recommendation = "SELL NOW"


        reasons.append(
            "Expected price decrease"
        )



    # 2. Low confidence

    elif (

        low_confidence

        and

        not waiting_is_profitable

    ):


        recommendation = "SELL NOW"


        reasons.append(
            "Low prediction confidence"
        )



    # 3. Crop cannot wait

    elif (

        waiting_risk

        and

        trend == "RISING"

    ):


        recommendation = "SELL NOW"


        reasons.append(
            "Waiting period exceeds crop shelf life"
        )



    # 4. Profitable waiting opportunity

    elif (

        waiting_is_profitable

        and

        strong_confidence

        and

        storage_available

        and

        range_supports_waiting

    ):


        if quantity > 1000:


            recommendation = "PARTIAL SELL"


            reasons.append(
                "Profit opportunity detected"
            )


            reasons.append(
                "Balanced selling and storage strategy"
            )


        else:


            recommendation = "CONSIDER WAITING"


            reasons.append(
                "Waiting improves net realization"
            )


            reasons.append(
                "Prediction confidence supports waiting"
            )



    # 5. Large quantity

    elif quantity > 1000:


        recommendation = "PARTIAL SELL"


        reasons.append(
            "Large quantity risk management"
        )



    # 6. Default

    else:


        recommendation = "SELL NOW"


        reasons.append(
            "No strong advantage in waiting"
        )





    # ========================================================
    # Quantity recommendation
    # ========================================================

    if quantity > 1000:


        quantity_strategy = calculate_quantity_strategy(

            quantity,

            trend,

            confidence_score,

            range_supports_waiting,

            storage_available,

            profit_difference

        )





    # ========================================================
    # Return
    # ========================================================

    return {


        "crop": crop,


        "current_price": current_price,


        "predicted_price": predicted_price,


        "expected_change_percent":

            round(
                change_percent,
                2
            ),


        "prediction_horizon_days":

            prediction_horizon_days,


        "confidence_score":

            round(
                confidence_score,
                2
            ),


        "expected_price_range": {

            "lower": lower_price,

            "upper": upper_price

        },


        "profit_analysis":

            profit_analysis,


        "trend":

            trend,


        "recommendation":

            recommendation,


        "reasons":

            reasons,


        "quantity_strategy":

            quantity_strategy,


        "crop_profile": {


            "shelf_life_days":

                shelf_life_days,


            "storage_risk":

                storage_risk,


            "cold_storage_required":

                cold_storage_required

        }

    }