import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';


class TermsConditionScreen extends StatefulWidget {

  const TermsConditionScreen({
    super.key,
  });


  @override
  State<TermsConditionScreen> createState() =>
      _TermsConditionScreenState();

}



class _TermsConditionScreenState
    extends State<TermsConditionScreen> {


  final ScrollController _controller =
      ScrollController();


  bool canContinue = false;



  @override
  void initState() {

    super.initState();


    _controller.addListener(() {

      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 20) {


        setState(() {

          canContinue = true;

        });


      }

    });


  }





  @override
  void dispose() {

    _controller.dispose();

    super.dispose();

  }






  void _continue(){

    if(!canContinue){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Please read the complete Terms & Conditions",
          ),

        ),

      );


      return;

    }



    Navigator.pop(
      context,
      true,
    );

  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      AppColors.background,



      appBar:

      AppBar(

        title:
        const Text(
          "Terms & Conditions",
        ),

        centerTitle:true,

      ),




      body:

      SafeArea(

        child:

        Padding(

          padding:
          const EdgeInsets.all(20),



          child:

          Column(

            children:[



              Expanded(

                child:

                Container(

                  padding:
                  const EdgeInsets.all(20),



                  decoration:

                  BoxDecoration(

                    color:
                    Colors.white,


                    borderRadius:
                    BorderRadius.circular(24),


                    boxShadow:[

                      BoxShadow(

                        color:
                        Colors.black
                            .withValues(
                          alpha:0.08,
                        ),

                        blurRadius:20,

                      ),

                    ],

                  ),




                  child:

                  SingleChildScrollView(


                    controller:
                    _controller,



                    child:

                    Column(


                      crossAxisAlignment:
                      CrossAxisAlignment.start,



                      children:[



                        const Icon(

                          Icons.agriculture,

                          size:55,

                          color:
                          AppColors.primary,

                        ),




                        const SizedBox(
                          height:20,
                        ),




                        const Text(

                          "Welcome to Farmora",

                          style:

                          TextStyle(

                            fontSize:26,

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),





                        const SizedBox(
                          height:20,
                        ),




                        _buildSection(

                          "1. About Farmora",

                          "Farmora is a digital agriculture platform that connects farmers, buyers and FPOs to create better opportunities.",

                        ),




                        _buildSection(

                          "2. Farmer Responsibilities",

                          "Farmers must provide correct crop details, quantity, location and other required information.",

                        ),




                        _buildSection(

                          "3. Data Privacy",

                          "Farmora protects user information and uses data only for providing platform services.",

                        ),




                        _buildSection(

                          "4. Market Information",

                          "Market prices, predictions and recommendations are provided to support farming decisions.",

                        ),




                        _buildSection(

                          "5. Buyer Connections",

                          "Farmora helps farmers discover buyers and improve selling opportunities.",

                        ),




                        _buildSection(

                          "6. Platform Usage",

                          "Users agree to use Farmora responsibly and provide genuine information.",

                        ),



                        const SizedBox(
                          height:50,
                        ),


                      ],

                    ),


                  ),


                ),


              ),





              const SizedBox(
                height:15,
              ),





              Row(

                children:[



                  Expanded(

                    child:

                    OutlinedButton(

                      onPressed:(){

                        Navigator.pop(
                          context,
                          false,
                        );

                      },


                      child:
                      const Text(
                        "Cancel",
                      ),

                    ),

                  ),





                  const SizedBox(
                    width:15,
                  ),




                  Expanded(

                    child:

                    ElevatedButton(

                      onPressed:
                      _continue,


                      child:

                      const Text(
                        "Continue",
                      ),

                    ),

                  ),


                ],

              )


            ],

          ),

        ),

      ),


    );


  }







  Widget _buildSection(
      String title,
      String content,
      ){

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom:25,
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

              fontSize:18,

              fontWeight:
              FontWeight.bold,

            ),

          ),




          const SizedBox(
            height:8,
          ),





          Text(

            content,

            style:

            const TextStyle(

              fontSize:15,

              height:1.5,

            ),

          ),


        ],

      ),

    );

  }


}