from crop_profile import get_crop_profile



# ============================================================
# Quantity Split Logic
# ============================================================

def calculate_quantity_strategy(
    quantity,
    trend,
    confidence_score,
    range_supports_waiting,
    storage_available
):


    # --------------------------------------------------------
    # Strong price opportunity
    # Store more because waiting is beneficial
    # --------------------------------------------------------

    if (
        trend == "RISING"
        and confidence_score >= 80
        and range_supports_waiting
        and storage_available
    ):

        sell_percentage = 0.40



    # --------------------------------------------------------
    # High risk situation
    # Sell maximum quantity
    # --------------------------------------------------------

    elif (
        trend == "FALLING"
        or confidence_score < 50
        or not storage_available
    ):

        sell_percentage = 0.90



    # --------------------------------------------------------
    # Normal situation
    # --------------------------------------------------------

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
    confidence_score
):


    # --------------------------------------------------------
    # Price Change
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
    # Crop Intelligence
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

        prediction_horizon_days

        >

        shelf_life_days

    )



    # --------------------------------------------------------
    # Prediction Intelligence
    # --------------------------------------------------------

    lower_price = expected_price_range[
        "lower"
    ]


    upper_price = expected_price_range[
        "upper"
    ]



    low_confidence = (

        confidence_score < 50

    )


    strong_confidence = (

        confidence_score >= 70

    )



    range_supports_waiting = (

        lower_price > current_price

    )



    reasons = []


    quantity_strategy = None



    # ========================================================
    # DECISION RULES
    # ========================================================



    # --------------------------------------------------------
    # 1. Falling price
    # --------------------------------------------------------

    if trend == "FALLING":


        recommendation = "SELL NOW"


        reasons.append(
            "Expected price decrease"
        )


        if quantity > 1000:

            quantity_strategy = calculate_quantity_strategy(

                quantity,

                trend,

                confidence_score,

                range_supports_waiting,

                storage_available

            )



    # --------------------------------------------------------
    # 2. Rising but low confidence
    # --------------------------------------------------------

    elif (

        trend == "RISING"

        and

        low_confidence

    ):


        recommendation = "SELL NOW"


        reasons.append(
            "Low prediction confidence"
        )



    # --------------------------------------------------------
    # 3. Waiting exceeds shelf life
    # --------------------------------------------------------

    elif (

        trend == "RISING"

        and

        waiting_risk

    ):


        recommendation = "SELL NOW"


        reasons.append(
            "Waiting period exceeds crop shelf life"
        )



    # --------------------------------------------------------
    # 4. Strong waiting opportunity
    # --------------------------------------------------------

    elif (

        trend == "RISING"

        and

        storage_available

        and

        storage_cost == "LOW"

        and

        strong_confidence

        and

        range_supports_waiting

        and

        not waiting_risk

        and

        (
            not cold_storage_required
            or storage_available
        )

    ):


        recommendation = "CONSIDER WAITING"


        reasons.append(
            "Expected price increase"
        )


        reasons.append(
            "High prediction confidence"
        )


        reasons.append(
            "Expected price range supports waiting"
        )


        reasons.append(
            f"Crop shelf life supports {prediction_horizon_days} days waiting"
        )


        if storage_risk == "HIGH":

            reasons.append(
                "Monitor spoilage risk"
            )



    # --------------------------------------------------------
    # 5. Large quantity management
    # --------------------------------------------------------

    elif quantity > 1000:


        recommendation = "PARTIAL SELL"


        reasons.append(
            "Large quantity risk management"
        )


        quantity_strategy = calculate_quantity_strategy(

            quantity,

            trend,

            confidence_score,

            range_supports_waiting,

            storage_available

        )



    # --------------------------------------------------------
    # 6. Default
    # --------------------------------------------------------

    else:


        recommendation = "SELL NOW"


        reasons.append(
            "No strong advantage in waiting"
        )



    # ========================================================
    # OUTPUT
    # ========================================================

    return {


        "crop": crop,


        "current_price":
            current_price,


        "predicted_price":
            predicted_price,


        "expected_change_percent":
            float(
                round(
                    change_percent,
                    2
                )
            ),


        "prediction_horizon_days":
            prediction_horizon_days,


        "confidence_score":
            confidence_score,


        "expected_price_range": {

            "lower":
                lower_price,

            "upper":
                upper_price

        },


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