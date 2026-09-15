import 'package:flutter/material.dart';


import '../../core/localization/app_localizations.dart';
import '../../core/localization/language_controller.dart';

import '../../widgets/farmora_logo.dart';
import '../../widgets/farmora_button.dart';
import '../../widgets/language_circle_card.dart';

import '../auth/account_access_screen.dart';



class LanguageSelectionScreen extends StatefulWidget {

  const LanguageSelectionScreen({
    super.key,
  });


  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();

}




class _LanguageSelectionScreenState
    extends State<LanguageSelectionScreen> {



  String? selectedLanguage;



  final languages = [


    {

      "native":"தமிழ்",

      "english":"Tamil",

      "code":"ta",

      "image":
      "assets/images/tamil_temple.png"

    },



    {

      "native":"मराठी",

      "english":"Marathi",

      "code":"mr",

      "image":
      "assets/images/marathi_temple.png"

    },



    {

      "native":"English",

      "english":"English",

      "code":"en",

      "image":
      "assets/images/english_temple.png"

    },


  ];






  void continueNext(){


    if(selectedLanguage == null){

      return;

    }



    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder:(context)=>

        const AccountAccessScreen(),

      ),

    );


  }








  @override
  Widget build(BuildContext context) {


    final local =
    AppLocalizations.of(context);



    final width =
    MediaQuery.of(context).size.width;





    return Scaffold(



      body: SafeArea(



        child: SingleChildScrollView(



          padding:

          EdgeInsets.symmetric(

            horizontal:

            width < 600 ? 24 : 80,

            vertical:30,

          ),



          child:

          Column(

            children: [



              const FarmoraLogo(),



              const SizedBox(height:20),




              Text(

                local.chooseLanguage,

                style:

                const TextStyle(

                  fontSize:30,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),





              const SizedBox(height:8),




              Text(

                local.languageSubtitle,

                textAlign:
                TextAlign.center,


                style:

                TextStyle(

                  color:
                  Colors.grey.shade600,

                  fontSize:16,

                ),

              ),




              const SizedBox(height:40),






              LayoutBuilder(

                builder:(context,constraints){


                  if(constraints.maxWidth < 700){



                    return Wrap(


                      alignment:
                      WrapAlignment.center,


                      spacing:25,

                      runSpacing:25,



                      children:

                      languages.map((lang){


                        return LanguageCircleCard(


                          imagePath:
                          lang["image"]!,


                          nativeName:
                          lang["native"]!,


                          englishName:
                          lang["english"]!,


                          selected:

                          selectedLanguage ==
                              lang["code"],



                          onTap:(){


                            setState((){


                              selectedLanguage =
                              lang["code"];

                            });



                            languageController
                                .setLanguage(
                                lang["code"]!
                            );

                          },

                        );


                      }).toList(),

                    );


                  }




                  return Row(


                    mainAxisAlignment:
                    MainAxisAlignment.center,


                    children:

                    languages.map((lang){


                      return Padding(

                        padding:
                        const EdgeInsets.all(20),


                        child:
                        LanguageCircleCard(


                          imagePath:
                          lang["image"]!,


                          nativeName:
                          lang["native"]!,


                          englishName:
                          lang["english"]!,



                          selected:

                          selectedLanguage ==
                              lang["code"],



                          onTap:(){


                            setState((){


                              selectedLanguage =
                              lang["code"];

                            });


                            languageController
                                .setLanguage(
                                lang["code"]!
                            );


                          },


                        ),

                      );


                    }).toList(),



                  );


                },

              ),





              const SizedBox(height:50),





              FarmoraButton(


                text:
                local.continueText,


                icon:
                Icons.arrow_forward,


                onPressed:

                selectedLanguage == null

                    ?

                null

                    :

                continueNext,


              ),




            ],

          ),



        ),


      ),


    );


  }

}