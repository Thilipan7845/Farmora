import 'package:flutter/material.dart';

import '../../services/logistics_service.dart';



class LogisticsScreen extends StatefulWidget {


  const LogisticsScreen({
    super.key,
  });



  @override
  State<LogisticsScreen> createState() =>
      _LogisticsScreenState();

}




class _LogisticsScreenState
    extends State<LogisticsScreen> {


  bool loading = true;


  List<dynamic> logistics = [];



  @override
  void initState(){

    super.initState();

    loadLogistics();

  }





  Future<void> loadLogistics() async {


    try{


      final data =
      await LogisticsService.getLogistics();



      setState(() {

        logistics=data;

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
          "Delivery Tracking",
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

      logistics.isEmpty


      ?

      const Center(

        child:

        Text(
          "No delivery available",
        ),

      )


      :

      ListView.builder(

        padding:

        const EdgeInsets.all(16),


        itemCount:

        logistics.length,


        itemBuilder:(context,index){


          final item =
          logistics[index];



          return Card(

            elevation:3,


            margin:

            const EdgeInsets.only(
              bottom:15,
            ),



            child:

            ListTile(


              leading:

              const CircleAvatar(

                child:

                Icon(
                  Icons.local_shipping,
                ),

              ),



              title:

              Text(

                item["vehicle"] ??
                "Transport",

              ),



              subtitle:

              Text(

                "Status: ${item["status"] ?? "Pending"}\n"
                "Location: ${item["location"] ?? "Unknown"}",

              ),



            ),


          );


        },

      ),


    );


  }


}