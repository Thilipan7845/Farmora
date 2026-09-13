import 'package:flutter/material.dart';

import '../../services/offer_service.dart';



class OffersScreen extends StatefulWidget {

  const OffersScreen({
    super.key,
  });


  @override
  State<OffersScreen> createState() =>
      _OffersScreenState();

}




class _OffersScreenState
    extends State<OffersScreen> {


  bool loading = true;


  List<dynamic> offers = [];



  @override
  void initState(){

    super.initState();

    loadOffers();

  }




  Future<void> loadOffers() async {


    try{


      final data =
      await OfferService.getOffers();



      setState(() {

        offers=data;

        loading=false;

      });


    }
    catch(e){


      setState(() {

        loading=false;

      });


    }


  }




  Future<void> updateStatus(
      String id,
      String status
      ) async {


    await OfferService.updateOfferStatus(
      id,
      status,
    );


    loadOffers();


  }




  @override
  Widget build(BuildContext context){


    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          "Crop Offers",
        ),

      ),



      body:


      loading

      ?

      const Center(
        child:
        CircularProgressIndicator(),
      )


      :

      offers.isEmpty


      ?

      const Center(

        child:
        Text(
          "No offers received",
        ),

      )


      :

      ListView.builder(

        padding:
        const EdgeInsets.all(16),


        itemCount:
        offers.length,


        itemBuilder:(context,index){


          final offer =
          offers[index];



          return Card(


            margin:
            const EdgeInsets.only(
              bottom:15,
            ),



            child:

            Padding(

              padding:
              const EdgeInsets.all(16),


              child:

              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children:[


                  Text(

                    offer["buyer_name"]
                    ??
                    "Buyer",

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

                    "Crop: ${offer["crop_name"]}",

                  ),



                  Text(

                    "Quantity: ${offer["quantity"]} kg",

                  ),



                  Text(

                    "Offer Price: ₹${offer["price"]}",

                  ),



                  const SizedBox(
                    height:15,
                  ),



                  Row(

                    children:[


                      Expanded(

                        child:
                        ElevatedButton(

                          onPressed:(){

                            updateStatus(

                              offer["id"]
                                  .toString(),

                              "accepted",

                            );

                          },


                          child:
                          const Text(
                            "Accept",
                          ),

                        ),

                      ),



                      const SizedBox(
                        width:10,
                      ),



                      Expanded(

                        child:
                        OutlinedButton(

                          onPressed:(){

                            updateStatus(

                              offer["id"]
                                  .toString(),

                              "rejected",

                            );

                          },


                          child:
                          const Text(
                            "Reject",
                          ),

                        ),

                      ),


                    ],

                  )


                ],


              ),

            ),


          );


        },

      ),


    );


  }


}