import 'package:flutter/material.dart';

import '../../services/farmer_service.dart';
import 'farmer_dashboard_screen.dart';



class FarmerRegistrationScreen extends StatefulWidget {

  const FarmerRegistrationScreen({super.key});


  @override
  State<FarmerRegistrationScreen> createState() =>
      _FarmerRegistrationScreenState();

}




class _FarmerRegistrationScreenState
    extends State<FarmerRegistrationScreen> {



  final _formKey =
      GlobalKey<FormState>();



  final villageController =
      TextEditingController();

  final districtController =
      TextEditingController();

  final stateController =
      TextEditingController();

  final landController =
      TextEditingController();

  final cultivatedController =
      TextEditingController();



  bool loading = false;



  final List<String> availableCrops = [

    "Cotton",
    "Rice",
    "Wheat",
    "Sugarcane",
    "Onion",
    "Tomato",

  ];



  final List<String> selectedCrops = [];





  @override
  void dispose(){

    villageController.dispose();

    districtController.dispose();

    stateController.dispose();

    landController.dispose();

    cultivatedController.dispose();

    super.dispose();

  }





  Future<void> saveProfile() async {


    if(!_formKey.currentState!.validate()){

      return;

    }



    if(selectedCrops.isEmpty){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:

          Text(
            "Select at least one crop",
          ),

        ),

      );


      return;

    }





    setState(() {

      loading=true;

    });




    try{


      await FarmerService.createProfile({


        "village":
        villageController.text.trim(),


        "district":
        districtController.text.trim(),


        "state":
        stateController.text.trim(),


        "total_land_area":

        double.parse(
          landController.text,
        ),


        "cultivated_area":

        double.parse(
          cultivatedController.text,
        ),



        "crops":
        selectedCrops,


      });





      if(!mounted)return;




      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const FarmerDashboardScreen(),

        ),

      );




    }


    catch(e){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:

          Text(
            e.toString(),
          ),

        ),

      );


    }



    finally{


      if(mounted){

        setState(() {

          loading=false;

        });

      }


    }


  }








  @override
  Widget build(BuildContext context){


    return Scaffold(



      backgroundColor:
      const Color(0xffF6FAF4),



      body:

      SafeArea(


        child:

        SingleChildScrollView(


          padding:
          const EdgeInsets.all(20),



          child:

          Form(

            key:
            _formKey,



            child:

            Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,



              children:[




                Container(


                  width:
                  double.infinity,


                  padding:
                  const EdgeInsets.all(24),



                  decoration:

                  BoxDecoration(


                    gradient:

                    const LinearGradient(

                      colors:[

                        Color(0xff2E7D32),

                        Color(0xff66BB6A),

                      ],

                    ),



                    borderRadius:

                    BorderRadius.circular(28),


                  ),




                  child:

                  Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,


                    children:[



                      const Icon(

                        Icons.agriculture,

                        color:
                        Colors.white,

                        size:
                        45,

                      ),



                      const SizedBox(
                        height:12,
                      ),



                      const Text(

                        "Welcome Farmer 🌱",

                        style:

                        TextStyle(

                          color:
                          Colors.white,

                          fontSize:
                          26,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),



                      const SizedBox(
                        height:6,
                      ),



                      const Text(

                        "Complete your farm profile",

                        style:

                        TextStyle(

                          color:
                          Colors.white70,

                          fontSize:
                          15,

                        ),

                      ),


                    ],


                  ),


                ),





                const SizedBox(
                  height:25,
                ),






                _sectionTitle(
                    "📍 Farm Location"
                ),



                _input(

                  villageController,

                  "Village",

                  Icons.location_on,

                ),



                _input(

                  districtController,

                  "District",

                  Icons.location_city,

                ),



                _input(

                  stateController,

                  "State",

                  Icons.map,

                ),





                const SizedBox(
                  height:20,
                ),






                _sectionTitle(
                    "🌾 Land Details"
                ),




                _input(

                  landController,

                  "Total Land (acres)",

                  Icons.landscape,

                  number:true,

                ),




                _input(

                  cultivatedController,

                  "Cultivated Area (acres)",

                  Icons.grass,

                  number:true,

                ),





                const SizedBox(
                  height:20,
                ),






                _sectionTitle(

                    "🌱 Select Crops"

                ),





                Wrap(

                  spacing:
                  10,


                  runSpacing:
                  10,



                  children:

                  availableCrops.map(

                          (crop){


                        final selected =

                        selectedCrops
                            .contains(crop);



                        return ChoiceChip(

                          label:

                          Text(crop),



                          selected:
                          selected,



                          onSelected:(value){


                            setState(() {


                              if(value){

                                selectedCrops
                                    .add(crop);

                              }

                              else{

                                selectedCrops
                                    .remove(crop);

                              }


                            });


                          },


                        );


                      }

                  ).toList(),


                ),





                const SizedBox(
                  height:35,
                ),






                SizedBox(

                  width:
                  double.infinity,


                  height:
                  55,



                  child:

                  ElevatedButton(


                    onPressed:

                    loading
                    ?
                    null
                    :
                    saveProfile,



                    style:

                    ElevatedButton.styleFrom(

                      backgroundColor:

                      const Color(
                          0xff2E7D32
                      ),



                      shape:

                      RoundedRectangleBorder(

                        borderRadius:

                        BorderRadius.circular(
                            18
                        ),

                      ),

                    ),



                    child:

                    loading

                    ?

                    const CircularProgressIndicator(
                      color:Colors.white,
                    )

                    :

                    const Text(

                      "Save Farm Profile",

                      style:

                      TextStyle(

                        fontSize:
                        17,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),



                  ),

                ),



              ],


            ),


          ),


        ),


      ),


    );


  }







  Widget _sectionTitle(String text){

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom:12,
      ),


      child:

      Text(

        text,

        style:

        const TextStyle(

          fontSize:
          20,

          fontWeight:
          FontWeight.bold,

        ),

      ),

    );


  }






  Widget _input(

      TextEditingController controller,

      String label,

      IconData icon,

      {bool number=false}

      ){


    return Padding(

      padding:
      const EdgeInsets.only(
        bottom:15,
      ),



      child:

      TextFormField(


        controller:
        controller,



        keyboardType:

        number

        ?

        TextInputType.number

        :

        TextInputType.text,



        validator:(value){


          if(value==null ||
              value.trim().isEmpty){

            return "Enter $label";

          }


          return null;

        },



        decoration:

        InputDecoration(


          labelText:
          label,



          prefixIcon:
          Icon(icon),



          filled:true,

          fillColor:
          Colors.white,



          border:

          OutlineInputBorder(

            borderRadius:

            BorderRadius.circular(16),

            borderSide:
            BorderSide.none,

          ),


        ),


      ),


    );


  }



}