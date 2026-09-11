# ============================================================
# Farmora Explanation Engine
# Converts ML decisions into farmer-friendly messages
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
    # Recommendation explanation
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
    # Quantity strategy explanation
    # --------------------------------------------------------

    quantity_message = None


    if quantity_strategy:


        sell_qty = quantity_strategy[
            "sell_now_quantity"
        ]


        store_qty = quantity_strategy[
            "store_quantity"
        ]


        quantity_message = (

            f"Sell {sell_qty} kg now "
            f"and store {store_qty} kg."
            
        )


        message_parts.append(
            quantity_message
        )



    # --------------------------------------------------------
    # Profit explanation
    # --------------------------------------------------------

    profit_message = None


    if profit_analysis:


        profit_difference = profit_analysis[
            "profit_difference"
        ]


        if profit_difference > 0:

            profit_message = (

                f"Expected additional benefit "
                f"is ₹{round(profit_difference,2)} "
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
    # Confidence explanation
    # --------------------------------------------------------

    if confidence_score >= 70:

        confidence = "HIGH"


    elif confidence_score >= 50:

        confidence = "MEDIUM"


    else:

        confidence = "LOW"



    return {


        "farmer_message":

            " ".join(message_parts),



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