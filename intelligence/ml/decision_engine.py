from crop_profile import get_crop_profile



def decide_sale(
    crop,
    prediction_horizon_days,
    current_price,
    predicted_price,
    storage_available,
    storage_cost,
    demand_level,
    quantity,
    confidence_score
):


    # -----------------------------
    # Price change calculation
    # -----------------------------

    change_percent = (
        (predicted_price - current_price)
        / current_price
    ) * 100



    # -----------------------------
    # Trend calculation
    # -----------------------------

    if change_percent > 2:

        trend = "RISING"


    elif change_percent < -2:

        trend = "FALLING"


    else:

        trend = "STABLE"



    # -----------------------------
    # Crop intelligence
    # -----------------------------

    crop_profile = get_crop_profile(crop)


    shelf_life_days = crop_profile[
        "shelf_life_days"
    ]


    cold_storage_required = crop_profile[
        "cold_storage_required"
    ]


    storage_risk = crop_profile[
        "storage_risk"
    ]



    waiting_risk = (
        prediction_horizon_days
        >
        shelf_life_days
    )



    # -----------------------------
    # Confidence intelligence
    # -----------------------------

    low_confidence = (
        confidence_score < 50
    )



    reasons = []



    # -----------------------------
    # Decision rules
    # -----------------------------



    # 1. Falling price

    if (
        trend == "FALLING"
        and
        (
            not storage_available
            or storage_cost == "HIGH"
        )
    ):


        recommendation = "SELL NOW"


        reasons.append(
            "Expected price decrease"
        )



    # 2. Rising but prediction confidence is low

    elif (
        trend == "RISING"
        and low_confidence
    ):


        recommendation = "SELL NOW"


        reasons.append(
            "Low prediction confidence"
        )



    # 3. Rising but shelf life risk

    elif (
        trend == "RISING"
        and waiting_risk
    ):


        recommendation = "SELL NOW"


        reasons.append(
            "Expected price increase period exceeds crop shelf life"
        )



    # 4. Rising + safe waiting

    elif (
        trend == "RISING"
        and storage_available
        and storage_cost == "LOW"
        and not waiting_risk
        and not low_confidence
        and (
            not cold_storage_required
            or storage_available
        )
    ):


        recommendation = "CONSIDER WAITING"


        reasons.append(
            "Expected price increase"
        )


        reasons.append(
            "Storage condition supports waiting"
        )


        reasons.append(
            f"Crop shelf life supports {prediction_horizon_days} days waiting"
        )


        if storage_risk == "HIGH":

            reasons.append(
                "Monitor crop spoilage risk"
            )



    # 5. Quantity risk

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



    return {


        "crop": crop,


        "current_price": current_price,


        "predicted_price": predicted_price,


        "expected_change_percent":
            float(round(change_percent,2)),


        "prediction_horizon_days":
            prediction_horizon_days,


        "confidence_score":
            confidence_score,


        "trend": trend,


        "recommendation":
            recommendation,


        "reasons":
            reasons,


        "crop_profile": {


            "shelf_life_days":
                shelf_life_days,


            "storage_risk":
                storage_risk,


            "cold_storage_required":
                cold_storage_required

        }

    }