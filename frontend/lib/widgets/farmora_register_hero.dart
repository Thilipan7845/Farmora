import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';



class FarmoraRegisterHero extends StatelessWidget {


  const FarmoraRegisterHero({
    super.key,
  });



  @override
  Widget build(BuildContext context) {


    final width =
        MediaQuery.of(context).size.width;


    final isDesktop =
        width > 700;



    return Column(

      children: [



        Image.asset(

          "assets/farmora_logo.png",

          height:
          isDesktop ? 120 : 90,

        ),




        const SizedBox(
          height:20,
        ),





        const Text(

          "Create your Farmora account",

          textAlign:
          TextAlign.center,


          style:

          TextStyle(

            fontSize:26,

            fontWeight:
            FontWeight.bold,

            color:
            AppColors.textPrimary,

          ),


        ),





        const SizedBox(
          height:8,
        ),





        const Text(

          "Join thousands of farmers growing smarter",

          textAlign:
          TextAlign.center,


          style:

          TextStyle(

            fontSize:15,

            color:
            AppColors.textSecondary,

          ),

        ),





        const SizedBox(
          height:25,
        ),






        AnimatedContainer(

          duration:
          const Duration(
            milliseconds:400,
          ),


          height:
          isDesktop ? 230 : 160,


          width:
          double.infinity,



          decoration:

          BoxDecoration(


            borderRadius:
            BorderRadius.circular(28),



            boxShadow:[


              BoxShadow(

                color:
                Colors.black
                    .withValues(
                  alpha:0.08,
                ),

                blurRadius:20,

                offset:
                const Offset(0,8),

              )


            ],


          ),




          child:

          ClipRRect(

            borderRadius:
            BorderRadius.circular(28),



            child:

            Image.asset(

              "assets/images/farm_landscape.png",


              fit:
              BoxFit.cover,


            ),


          ),


        ),





      ],


    );


  }


}