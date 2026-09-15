import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';



Future<bool?> showTermsConditionDialog(
    BuildContext context,
    ) {


  return showModalBottomSheet<bool>(


    context: context,


    isScrollControlled: true,



    backgroundColor:

    Colors.transparent,



    builder:(context){



      return Container(


        height:

        MediaQuery.of(context).size.height * 0.75,



        padding:

        const EdgeInsets.all(24),



        decoration:

        const BoxDecoration(



          color:

          Colors.white,



          borderRadius:

          BorderRadius.vertical(

            top:

            Radius.circular(30),

          ),



        ),




        child:

        Column(


          children:[



            Container(


              width:50,

              height:5,


              decoration:

              BoxDecoration(

                color:

                Colors.grey.shade300,


                borderRadius:

                BorderRadius.circular(10),

              ),


            ),





            const SizedBox(
              height:20,
            ),





            const Text(


              "Farmora Terms & Conditions",



              style:

              TextStyle(

                fontSize:22,

                fontWeight:
                FontWeight.bold,

              ),



            ),





            const SizedBox(
              height:20,
            ),






            Expanded(


              child:

              SingleChildScrollView(



                child:

                Column(



                  crossAxisAlignment:

                  CrossAxisAlignment.start,



                  children:[



                    _text(

                      "1. About Farmora",

                      "Farmora connects farmers, buyers and FPOs through a digital agriculture platform.",

                    ),




                    _text(

                      "2. Farmer Responsibility",

                      "Farmers must provide accurate crop details, location and farming information.",

                    ),




                    _text(

                      "3. Data Privacy",

                      "Farmora protects user information and uses data only for platform services.",

                    ),




                    _text(

                      "4. Market Information",

                      "Market predictions and recommendations are provided only for decision support.",

                    ),




                    _text(

                      "5. Platform Usage",

                      "Users agree to use Farmora responsibly.",

                    ),



                  ],


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

                    onPressed:(){

                      Navigator.pop(
                        context,
                        true,
                      );

                    },


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


      );


    },


  );


}






Widget _text(

    String title,

    String body,

    ){


  return Padding(


    padding:

    const EdgeInsets.only(

      bottom:20,

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
          height:8,
        ),





        Text(

          body,


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