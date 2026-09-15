# ============================================================
# Farmora Explanation Engine
# Converts ML decisions into farmer-friendly messages
# Localization-friendly output
# ============================================================


def generate_farmer_explanation(
    recommendation,
    reasons,
    profit_analysis,
    quantity_strategy,
    crop,
    confidence_score
):

    message_parts = []

    # --------------------------------------------------------
    # Recommendation explanation (legacy farmer_message)
    # --------------------------------------------------------

    if recommendation == "SELL NOW":

        message_parts.append(
            f"Sell your {crop} now to avoid possible price loss."
        )


    elif recommendation == "CONSIDER WAITING":

        message_parts.append(
            f"Waiting may give better returns for your {crop}."
        )


    elif recommendation == "PARTIAL SELL":

        message_parts.append(
            f"Split your {crop} quantity to reduce risk and improve returns."
        )


    # --------------------------------------------------------
    # Quantity strategy
    # --------------------------------------------------------

    sell_quantity = 0
    store_quantity = 0

    quantity_message = None


    if quantity_strategy:

        sell_quantity = quantity_strategy.get(
            "sell_now_quantity",
            0
        )

        store_quantity = quantity_strategy.get(
            "store_quantity",
            0
        )


        quantity_message = (
            f"Sell {sell_quantity} kg now "
            f"and store {store_quantity} kg."
        )


        message_parts.append(
            quantity_message
        )


    # --------------------------------------------------------
    # Profit explanation
    # --------------------------------------------------------

    profit_message = None
    expected_benefit = 0


    if profit_analysis:

        profit_difference = profit_analysis.get(
            "profit_difference",
            0
        )


        expected_benefit = round(
            profit_difference,
            2
        )


        if profit_difference > 0:

            profit_message = (
                f"Expected additional benefit "
                f"is ₹{expected_benefit} "
                f"by following this strategy."
            )


            message_parts.append(
                profit_message
            )


        else:

            profit_message = (
                "Selling now gives better expected realization."
            )


            message_parts.append(
                profit_message
            )


    # --------------------------------------------------------
    # Confidence
    # --------------------------------------------------------

    if confidence_score >= 70:

        confidence = "HIGH"


    elif confidence_score >= 50:

        confidence = "MEDIUM"


    else:

        confidence = "LOW"


    # --------------------------------------------------------
    # Localization message key
    # --------------------------------------------------------

    if recommendation == "PARTIAL SELL":

        message_key = "PARTIAL_SELL_EXPLANATION"


    elif recommendation == "SELL NOW":

        message_key = "SELL_NOW_EXPLANATION"


    elif recommendation == "CONSIDER WAITING":

        message_key = "CONSIDER_WAITING_EXPLANATION"


    else:

        message_key = "GENERAL_EXPLANATION"



    # --------------------------------------------------------
    # Final response
    # --------------------------------------------------------

    return {

        # Keep old field for backward compatibility
        "farmer_message":
            " ".join(message_parts),


        # New localization-friendly format
        "farmer_explanation": {

            "message_key":
                message_key,


            "parameters": {

                "crop":
                    crop,


                "sell_quantity":
                    sell_quantity,


                "store_quantity":
                    store_quantity,


                "expected_benefit":
                    expected_benefit
            }
        },


        "action":
            recommendation,


        "confidence":
            confidence,


        "reasons":
            reasons,


        "quantity_strategy":
            quantity_strategy,


        "profit_summary":
            profit_message
    }