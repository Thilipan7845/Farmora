import 'package:flutter/material.dart';

import '../../services/crop_service.dart';



class AddCropLotScreen extends StatefulWidget {

  const AddCropLotScreen({super.key});


  @override
  State<AddCropLotScreen> createState() =>
      _AddCropLotScreenState();

}



class _AddCropLotScreenState
    extends State<AddCropLotScreen> {


  final _formKey =
      GlobalKey<FormState>();


  final cropController =
      TextEditingController();


  final quantityController =
      TextEditingController();


  final priceController =
      TextEditingController();



  bool loading = false;





  @override
  void dispose() {

    cropController.dispose();

    quantityController.dispose();

    priceController.dispose();

    super.dispose();

  }






  Future<void> saveCrop() async {


    if(!_formKey.currentState!.validate()) {

      return;

    }




    setState(() {

      loading = true;

    });




    try {



      final cropData = {


        "crop_name":
        cropController.text.trim(),



        "quantity":

        double.parse(
          quantityController.text.trim(),
        ),



        "expected_price":

        double.parse(
          priceController.text.trim(),
        ),


      };




      await CropService.createCropLot(
        cropData,
      );




      if(!mounted) return;




      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:

          Text(
            "Crop lot created successfully",
          ),

        ),

      );

Navigator.pop(context, true);



    }


    catch(e){


      if(!mounted) return;



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

          loading = false;

        });

      }


    }



  }






  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar:

      AppBar(

        title:

        const Text(
          "Add Crop Lot",
        ),

      ),




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

              children:[




                TextFormField(

                  controller:
                  cropController,


                  decoration:

                  const InputDecoration(

                    labelText:
                    "Crop Name",


                    prefixIcon:

                    Icon(
                      Icons.grass,
                    ),

                  ),



                  validator:(value){


                    if(value==null ||
                        value.trim().isEmpty){

                      return "Enter crop name";

                    }


                    return null;

                  },


                ),




                const SizedBox(
                  height:16,
                ),





                TextFormField(

                  controller:
                  quantityController,


                  keyboardType:

                  TextInputType.number,



                  decoration:

                  const InputDecoration(

                    labelText:
                    "Quantity (kg)",


                    prefixIcon:

                    Icon(
                      Icons.inventory_2,
                    ),

                  ),



                  validator:(value){


                    if(value==null ||
                        value.isEmpty){

                      return "Enter quantity";

                    }



                    if(double.tryParse(value)==null){

                      return "Enter valid quantity";

                    }


                    return null;

                  },


                ),




                const SizedBox(
                  height:16,
                ),





                TextFormField(

                  controller:
                  priceController,


                  keyboardType:

                  TextInputType.number,



                  decoration:

                  const InputDecoration(

                    labelText:
                    "Expected Price",


                    prefixIcon:

                    Icon(
                      Icons.currency_rupee,
                    ),

                  ),




                  validator:(value){


                    if(value==null ||
                        value.isEmpty){

                      return "Enter expected price";

                    }




                    if(double.tryParse(value)==null){

                      return "Enter valid price";

                    }


                    return null;


                  },


                ),






                const SizedBox(
                  height:30,
                ),






                SizedBox(

                  width:

                  double.infinity,



                  height:

                  52,



                  child:

                  ElevatedButton(


                    onPressed:

                    loading

                    ?

                    null

                    :

                    saveCrop,




                    child:


                    loading


                    ?

                    const SizedBox(

                      height:22,

                      width:22,

                      child:

                      CircularProgressIndicator(

                        color:
                        Colors.white,

                        strokeWidth:
                        2,

                      ),

                    )



                    :


                    const Text(

                      "Create Crop Lot",

                      style:

                      TextStyle(

                        fontSize:16,

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


}