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


  bool loading=true;


  Map<String,dynamic>? result;




  @override
  void initState(){

    super.initState();

    loadDecision();

  }





  Future<void> loadDecision() async {


    try{


      final response =

await IntelligenceService.getDecision({

  "crop_name": widget.crop,
 "quantity": widget.quantity,
  "location": "Tamil Nadu",

});



      setState(() {

        result=response;

        loading=false;

      });


    }


    catch(e){


      setState(() {

        loading=false;

      });


    }


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


      loading

      ?

      const Center(

        child:

        CircularProgressIndicator(),

      )

      :


      result==null


      ?

      const Center(

        child:

        Text(
          "No recommendation available",
        ),

      )

      :


      Padding(

        padding:

        const EdgeInsets.all(20),



        child:

        Column(

          children:[


            _card(

              "Crop",

              widget.crop,

              Icons.grass,

            ),



            _card(

              "Current Price",

              "₹${result!["current_price"]}",

              Icons.currency_rupee,

            ),




            _card(

              "Predicted Price",

              "₹${result!["predicted_price"]}",

              Icons.trending_up,

            ),




            _card(

              "Trend",

              result!["trend"],

              Icons.analytics,

            ),





            _card(

              "Recommendation",

              result!["recommendation"],

              Icons.lightbulb,

            ),




           Container(

  padding:
  const EdgeInsets.all(18),


  margin:
  const EdgeInsets.only(bottom:15),


  decoration:

  BoxDecoration(

    color:
    const Color(0xFFE8F5E9),


    borderRadius:
    BorderRadius.circular(18),

  ),



  child:

  Text(

    "AI Confidence : ${result!["confidence"]}%",


    style:

    const TextStyle(

      fontSize:18,

      fontWeight:
      FontWeight.bold,


      color:
      Color(0xFF2E7D32),

    ),

  ),

),



          ],

        ),

      ),



    );


  }

Widget _card(
  String title,
  String value,
  IconData icon,
) {

  return Container(

    margin:
    const EdgeInsets.only(bottom:15),


    padding:
    const EdgeInsets.all(18),


    decoration:

    BoxDecoration(

      color:
      Colors.white,


      borderRadius:
      BorderRadius.circular(20),
boxShadow: [

  BoxShadow(

    color:
    Colors.grey.withValues(
      alpha: 0.15,
    ),

    blurRadius: 10,

    offset:
    const Offset(0,5),

  ),

],

    ),



    child:

    Row(

      children:[


        Container(

          height:50,

          width:50,


          decoration:

          BoxDecoration(

            color:
            const Color(0xFFE8F5E9),


            borderRadius:
            BorderRadius.circular(15),

          ),



          child:

          Icon(

            icon,

            color:
            const Color(0xFF2E7D32),

          ),

        ),



        const SizedBox(width:15),



        Expanded(

          child:

          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,


            children:[


              Text(

                title,

                style:

                TextStyle(

                  color:
                  Colors.grey.shade600,

                  fontSize:13,

                ),

              ),



              const SizedBox(height:5),



              Text(

                value,

                style:

                const TextStyle(

                  fontSize:18,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),


            ],

          ),

        )


      ],

    ),


  );

}}