import 'package:flutter/material.dart';

import '../../services/buyer_matching_service.dart';



class BuyerMatchingScreen extends StatefulWidget {


  final String crop;


  final double quantity;



  const BuyerMatchingScreen({

    super.key,

    required this.crop,

    required this.quantity,

  });



  @override
  State<BuyerMatchingScreen> createState() =>
      _BuyerMatchingScreenState();

}





class _BuyerMatchingScreenState
    extends State<BuyerMatchingScreen> {


  bool loading = true;


  List<dynamic> buyers = [];



  @override
  void initState(){

    super.initState();

    loadBuyers();

  }





  Future<void> loadBuyers() async {


    try{


      final response =
      await BuyerMatchingService.findBuyers({

        "crop_name": widget.crop,

        "quantity": widget.quantity,

      });



      setState(() {

        buyers = response;

        loading=false;

      });



    }

    catch(e){


      setState(() {

        loading=false;

      });


    }


  }





  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar: AppBar(

        title:
        const Text(
          "Find Buyers",
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

      buyers.isEmpty


      ?

      const Center(

        child:
        Text(
          "No buyers found",
        ),

      )


      :

      ListView.builder(

        padding:
        const EdgeInsets.all(16),


        itemCount:
        buyers.length,


        itemBuilder:(context,index){


          final buyer =
          buyers[index];



          return Card(


            margin:
            const EdgeInsets.only(
              bottom:15,
            ),


            child:

            ListTile(


              leading:

              CircleAvatar(

                child:
                Text(
                  "${buyer["match_score"]}%",
                ),

              ),



              title:

              Text(

                buyer["buyer_name"]
                ??
                "Buyer",

                style:
                const TextStyle(

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              subtitle:

              Text(

                "Needs: ${buyer["required_quantity"]} kg\n"
                "Location: ${buyer["location"]}",

              ),


            ),

          );


        },

      ),


    );

  }


}