# ============================================================
# Farmora Explanation Engine
# Converts ML decisions into localization-friendly responses
# ============================================================


def generate_farmer_explanation(
    recommendation,
    reasons,
    profit_analysis,
    quantity_strategy,
    crop,
    confidence_score
):


    # --------------------------------------------------------
    # Confidence classification
    # --------------------------------------------------------

    if confidence_score >= 70:

        confidence = "HIGH"


    elif confidence_score >= 50:

        confidence = "MEDIUM"


    else:

        confidence = "LOW"



    # --------------------------------------------------------
    # Explanation key selection
    # --------------------------------------------------------

    if recommendation == "SELL_NOW":

        message_key = "SELL_NOW_EXPLANATION"


    elif recommendation == "CONSIDER_WAITING":

        message_key = "CONSIDER_WAITING_EXPLANATION"


    elif recommendation == "PARTIAL_SELL":

        message_key = "PARTIAL_SELL_EXPLANATION"


    else:

        message_key = "GENERAL_EXPLANATION"



    # --------------------------------------------------------
    # Dynamic parameters
    # --------------------------------------------------------

    parameters = {}



    # Quantity information

    if quantity_strategy:


        parameters["sell_quantity"] = (

            quantity_strategy[
                "sell_now_quantity"
            ]

        )


        parameters["store_quantity"] = (

            quantity_strategy[
                "store_quantity"
            ]

        )



    # Profit information

    profit_summary = None


    if profit_analysis:


        profit_difference = profit_analysis[

            "profit_difference"

        ]


        parameters["expected_benefit"] = round(

            profit_difference,

            2

        )


        profit_summary = {

            "profit_difference":

                round(
                    profit_difference,
                    2
                )

        }



    # --------------------------------------------------------
    # Return localization-ready response
    # --------------------------------------------------------

    return {


        "message_key":

            message_key,


        "parameters":

            parameters,


        "action":

            recommendation,


        "confidence":

            confidence,


        "reasons":

            reasons,


        "quantity_strategy":

            quantity_strategy,


        "profit_summary":

            profit_summary

    }