import 'package:flutter/material.dart';

import '../../services/intelligence_service.dart';


class IntelligenceScreen extends StatefulWidget {


  final String crop;

  final double quantity;


  const IntelligenceScreen({

    super.key,

    required this.crop,

    required this.quantity,

  });



  @override
  State<IntelligenceScreen> createState() =>
      _IntelligenceScreenState();

}





class _IntelligenceScreenState
    extends State<IntelligenceScreen> {


  bool loading = true;


  Map<String,dynamic>? result;


  String? errorMessage;




  @override
  void initState(){

    super.initState();

    loadDecision();

  }







  Future<void> loadDecision() async {


    setState(() {

      loading = true;

      errorMessage = null;

    });



    try{


      final response =
      await IntelligenceService.getDecision({

        // Backend contract fields

        "crop": widget.crop,


        "market": "Tamil Nadu",


        "variety": null,


      });





      if(!mounted) return;




      setState(() {


        result = response;


        loading = false;


      });



    }


    catch(e){


      if(!mounted) return;



      setState(() {


        loading = false;


        errorMessage = e.toString();


      });


    }


  }






  String _value(dynamic value){


    if(value == null){

      return "—";

    }


    return value.toString();


  }







  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar:

      AppBar(

        title:

        const Text(
          "Farmora Intelligence",
        ),

      ),





      body:

      RefreshIndicator(

        onRefresh: loadDecision,


        child:

        SingleChildScrollView(

          physics:

          const AlwaysScrollableScrollPhysics(),


          padding:

          const EdgeInsets.all(20),



          child:

          _buildBody(),


        ),

      ),



    );


  }







  Widget _buildBody(){



    if(loading){


      return const SizedBox(

        height:500,


        child:

        Center(

          child:

          CircularProgressIndicator(),

        ),

      );


    }






    if(errorMessage != null){


      return SizedBox(


        height:500,


        child:

        Center(

          child:

          Column(

            mainAxisAlignment:
            MainAxisAlignment.center,


            children:[


              const Icon(

                Icons.error_outline,

                size:60,

                color:Colors.red,

              ),



              const SizedBox(
                height:15,
              ),




              const Text(

                "Unable to load AI recommendation",

                style:

                TextStyle(

                  fontSize:18,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              const SizedBox(
                height:10,
              ),



              Text(
                errorMessage!,
              ),




              const SizedBox(
                height:20,
              ),



              ElevatedButton(

                onPressed:
                loadDecision,


                child:

                const Text(
                  "Retry",
                ),

              )



            ],


          ),


        ),


      );


    }






    if(result == null){


      return const SizedBox(


        height:500,


        child:

        Center(

          child:

          Text(
            "No recommendation available",
          ),

        ),


      );


    }






    final data = result!;



    return Column(


      children:[



        Container(


          width:

          double.infinity,


          padding:

          const EdgeInsets.all(22),


          margin:

          const EdgeInsets.only(
            bottom:20,
          ),



          decoration:

          BoxDecoration(


            color:
            const Color(0xFFE8F5E9),



            borderRadius:

            BorderRadius.circular(24),


          ),




          child:

          Column(

            crossAxisAlignment:

            CrossAxisAlignment.start,



            children:[



              const Text(

                "AI Market Intelligence",

                style:

                TextStyle(

                  fontSize:22,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              const SizedBox(
                height:8,
              ),



              Text(

                "${widget.crop} • ${widget.quantity} kg",

                style:

                TextStyle(

                  color:
                  Colors.grey.shade700,

                ),

              )



            ],


          ),


        ),







        _card(

          "Current Price",

          "₹${_value(data["current_price"])}",

          Icons.currency_rupee,

        ),




        _card(

          "Predicted Price",

          "₹${_value(data["predicted_price"])}",

          Icons.trending_up,

        ),




        _card(

          "Expected Change",

          "${_value(data["expected_change_percent"])}%",

          Icons.show_chart,

        ),




        _card(

          "Market Trend",

          _value(data["trend"]),

          Icons.analytics,

        ),




        _card(

          "Recommendation",

          _value(data["recommendation"]),

          Icons.lightbulb,

        ),




        _card(

          "AI Confidence",

          "${_value(data["confidence_score"])}%",

          Icons.verified,

        ),





        if(data["reasons"] != null)

          _infoCard(

            "Why this recommendation?",

            data["reasons"],

          ),





        if(data["quantity_strategy"] != null)

          _infoCard(

            "Quantity Strategy",

            data["quantity_strategy"],

          ),





        if(data["farmer_explanation"] != null)

          _infoCard(

            "What this means for you",

            data["farmer_explanation"],

          ),





        OutlinedButton.icon(

          onPressed:
          loadDecision,


          icon:

          const Icon(
            Icons.refresh,
          ),



          label:

          const Text(
            "Refresh AI Decision",
          ),


        )



      ],


    );



  }







  Widget _card(

      String title,

      String value,

      IconData icon,

      ){



    return Container(


      margin:

      const EdgeInsets.only(
        bottom:15,
      ),



      padding:

      const EdgeInsets.all(18),



      decoration:

      BoxDecoration(


        color:

        Colors.white,



        borderRadius:

        BorderRadius.circular(20),



        boxShadow:[


          BoxShadow(

            color:

            Colors.grey.withValues(
              alpha:0.15,
            ),


            blurRadius:10,


          )


        ],



      ),




      child:

      Row(


        children:[


          Icon(

            icon,

            color:

            const Color(
              0xFF2E7D32,
            ),

          ),



          const SizedBox(
            width:15,
          ),



          Expanded(

            child:

            Column(

              crossAxisAlignment:

              CrossAxisAlignment.start,



              children:[



                Text(

                  title,

                ),



                const SizedBox(
                  height:5,
                ),



                Text(

                  value,

                  style:

                  const TextStyle(

                    fontSize:18,

                    fontWeight:
                    FontWeight.bold,

                  ),

                )



              ],


            ),


          )



        ],


      ),


    );


  }








  Widget _infoCard(

      String title,

      dynamic value,

      ){


    return Container(


      width:

      double.infinity,



      margin:

      const EdgeInsets.only(
        bottom:15,
      ),




      padding:

      const EdgeInsets.all(18),




      decoration:

      BoxDecoration(

        color:

        Colors.white,

        borderRadius:

        BorderRadius.circular(20),

      ),





      child:

      Column(

        crossAxisAlignment:

        CrossAxisAlignment.start,



        children:[



          Text(

            title,

            style:

            const TextStyle(

              fontSize:17,

              fontWeight:
              FontWeight.bold,

            ),

          ),




          const SizedBox(
            height:10,
          ),




          Text(

            value is List

            ? value
                .map((e)=>"• $e")
                .join("\n")

            : value.toString(),


          )


        ],


      ),


    );


  }


}