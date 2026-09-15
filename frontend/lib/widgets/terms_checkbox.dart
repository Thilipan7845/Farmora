import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';


class TermsCheckbox extends StatelessWidget {


  final bool accepted;

  final VoidCallback onTap;

  final VoidCallback onTermsTap;



  const TermsCheckbox({

    super.key,

    required this.accepted,

    required this.onTap,

    required this.onTermsTap,

  });




  @override
  Widget build(BuildContext context) {


    return Row(


      crossAxisAlignment:

      CrossAxisAlignment.center,



      children:[



        AnimatedContainer(


          duration:

          const Duration(
            milliseconds:200,
          ),



          child:

          Checkbox(

            value:

            accepted,


            activeColor:

            AppColors.primary,


            onChanged:(_){

              onTap();

            },


          ),


        ),




        Expanded(



          child:

          Wrap(



            children:[



              const Text(
                "I agree to ",
              ),



              GestureDetector(



                onTap:

                onTermsTap,



                child:

                const Text(



                  "Terms & Conditions",



                  style:

                  TextStyle(



                    color:

                    AppColors.primary,



                    fontWeight:

                    FontWeight.bold,



                  ),


                ),



              ),



            ],


          ),


        ),



      ],


    );


  }


}