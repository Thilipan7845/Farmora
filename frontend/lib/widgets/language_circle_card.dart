import 'package:flutter/material.dart';


class LanguageCircleCard extends StatelessWidget {


  final String imagePath;

  final String nativeName;

  final String englishName;

  final bool selected;

  final VoidCallback onTap;



  const LanguageCircleCard({

    super.key,

    required this.imagePath,

    required this.nativeName,

    required this.englishName,

    required this.selected,

    required this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    final screenWidth =
        MediaQuery.of(context).size.width;



    double cardSize;



    if(screenWidth < 600){

      cardSize = 130;

    }

    else if(screenWidth < 1200){

      cardSize = 160;

    }

    else{

      cardSize = 190;

    }





    return GestureDetector(

      onTap: onTap,


      child: AnimatedScale(

        scale: selected ? 1.12 : 1,


        duration:
        const Duration(milliseconds:250),



        child: AnimatedContainer(

          duration:
          const Duration(milliseconds:250),



          width: cardSize,

          height: cardSize,



          decoration: BoxDecoration(


            shape: BoxShape.circle,


            color: Colors.white,


            border: Border.all(

              color: selected

                  ? Theme.of(context)
                  .colorScheme
                  .primary

                  : Colors.grey.shade300,


              width: selected ? 4 : 2,

            ),



            boxShadow: [


              BoxShadow(

                color:

                selected

                    ?

                Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha:0.25)

                    :

                Colors.black12,


                blurRadius:20,

                spreadRadius:2,

              )


            ],


          ),




          child: Column(

            mainAxisAlignment:
            MainAxisAlignment.center,


            children: [



              SizedBox(

                height: cardSize * 0.45,

                width: cardSize * 0.45,


                child: Image.asset(

                  imagePath,

                  fit: BoxFit.contain,

                ),

              ),



              const SizedBox(height:6),



              Text(

                nativeName,

                style: const TextStyle(

                  fontSize:18,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),




              Text(

                englishName,

                style: TextStyle(

                  fontSize:12,

                  color:
                  Colors.grey.shade600,

                ),

              ),



              if(selected)

                Icon(

                  Icons.check_circle,

                  size:18,

                  color:

                  Theme.of(context)
                      .colorScheme
                      .primary,

                )



            ],

          ),


        ),

      ),

    );

  }

}