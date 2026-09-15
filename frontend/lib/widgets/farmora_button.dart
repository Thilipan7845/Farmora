import 'package:flutter/material.dart';


class FarmoraButton extends StatelessWidget {


  final String text;


  final VoidCallback? onPressed;


  final IconData? icon;


  final bool loading;



  const FarmoraButton({

    super.key,

    required this.text,

    this.onPressed,

    this.icon,

    this.loading = false,

  });







  @override
  Widget build(BuildContext context) {



    return LayoutBuilder(

      builder:(context,constraints){


        double width;



        if(constraints.maxWidth < 600){

          width =
          double.infinity;

        }

        else{

          width =
          360;

        }





        return SizedBox(


          width:width,


          height:56,



          child:

          ElevatedButton(



            onPressed:

            loading

                ?

            null

                :

            onPressed,



            style:

            ElevatedButton.styleFrom(


              backgroundColor:

              const Color(0xff2E7D32),



              foregroundColor:

              Colors.white,



              shape:

              RoundedRectangleBorder(

                borderRadius:

                BorderRadius.circular(18),

              ),


            ),



            child:

            loading

                ?


            const SizedBox(

              width:22,

              height:22,

              child:

              CircularProgressIndicator(

                color:Colors.white,

                strokeWidth:2,

              ),

            )

                :


            Row(


              mainAxisAlignment:

              MainAxisAlignment.center,



              children:[



                if(icon != null)

                  Icon(icon),



                if(icon != null)

                  const SizedBox(
                    width:8,
                  ),



                Text(

                  text,

                  style:

                  const TextStyle(

                    fontSize:16,

                    fontWeight:

                    FontWeight.w600,

                  ),

                ),



              ],


            ),



          ),


        );


      },


    );


  }

}