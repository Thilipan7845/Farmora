import 'package:flutter/material.dart';


class FarmoraCard extends StatelessWidget {


  final Widget child;

  final EdgeInsets? padding;

  final VoidCallback? onTap;

  final bool selected;



  const FarmoraCard({

    super.key,

    required this.child,

    this.padding,

    this.onTap,

    this.selected = false,

  });





  @override
  Widget build(BuildContext context) {


    return LayoutBuilder(

      builder: (context,constraints){


        return InkWell(

          onTap: onTap,


          borderRadius:
          BorderRadius.circular(24),



          child: AnimatedContainer(


            duration:
            const Duration(
              milliseconds:250,
            ),



            width:

            constraints.maxWidth,



            padding:

            padding ??

            const EdgeInsets.all(20),



            decoration:

            BoxDecoration(


              color:

              Colors.white,



              borderRadius:

              BorderRadius.circular(24),



              border:

              Border.all(


                color:

                selected

                    ?

                const Color(0xff2E7D32)

                    :

                Colors.grey.shade200,



                width:

                selected ? 2 : 1,


              ),




              boxShadow:[


                BoxShadow(


                  color:

                  Colors.black.withValues(
                    alpha:0.08,
                  ),



                  blurRadius:18,



                  offset:

                  const Offset(0,8),



                ),


              ],


            ),




            child: child,


          ),


        );


      },

    );


  }

}