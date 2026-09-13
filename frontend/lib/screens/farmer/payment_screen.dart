import 'package:flutter/material.dart';

import '../../services/payment_service.dart';



class PaymentScreen extends StatefulWidget {


  const PaymentScreen({
    super.key,
  });



  @override
  State<PaymentScreen> createState() =>
      _PaymentScreenState();


}




class _PaymentScreenState
    extends State<PaymentScreen> {


  bool loading = true;


  List<dynamic> payments = [];




  @override
  void initState(){

    super.initState();

    loadPayments();

  }




  Future<void> loadPayments() async {


    try{


      final data =
      await PaymentService.getPayments();



      setState(() {

        payments=data;

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
          "Payments",
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

      payments.isEmpty


      ?

      const Center(

        child:

        Text(
          "No payments found",
        ),

      )


      :

      ListView.builder(


        padding:

        const EdgeInsets.all(16),



        itemCount:

        payments.length,



        itemBuilder:(context,index){



          final payment =
          payments[index];



          return Container(


            margin:

            const EdgeInsets.only(
              bottom:15,
            ),


            padding:

            const EdgeInsets.all(18),



            decoration:

            BoxDecoration(

              color:Colors.white,

              borderRadius:

              BorderRadius.circular(18),

            ),



            child:Column(


              crossAxisAlignment:

              CrossAxisAlignment.start,



              children:[


                Text(

                  "₹${payment["amount"] ?? 0}",

                  style:

                  const TextStyle(

                    fontSize:24,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),



                const SizedBox(
                  height:8,
                ),



                Text(

                  "Status: ${payment["status"] ?? "Pending"}",

                ),



                Text(

                  "Order ID: ${payment["order_id"] ?? "-"}",

                ),



              ],


            ),


          );


        },

      ),


    );


  }


}