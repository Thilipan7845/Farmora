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


  Map<String,dynamic>? payment;



  @override
  void initState(){

    super.initState();

    loadPayment();

  }




  Future<void> loadPayment() async {


    try{


      final data =
      await PaymentService
          .getFarmerPaymentSummary();



      if(!mounted) return;


      setState(() {

        payment=data;

        loading=false;

      });



    }
    catch(e){


      if(!mounted) return;


      setState(() {

        loading=false;

      });


    }


  }





  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar:

      AppBar(

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


      payment == null


      ?

      const Center(

        child:

        Text(
          "No payment data available",
        ),

      )


      :


      ListView(

        padding:

        const EdgeInsets.all(16),


        children:[



          _paymentCard(

            "Total Sales",

            payment!["total_sales"],

            Icons.analytics,

          ),



          _paymentCard(

            "Received",

            payment!["received"],

            Icons.check_circle,

          ),



          _paymentCard(

            "Pending",

            payment!["pending"],

            Icons.pending,

          ),



          _paymentCard(

            "Expenses",

            payment!["expenses"],

            Icons.money_off,

          ),



          _paymentCard(

            "Net Amount",

            payment!["net_amount"],

            Icons.account_balance_wallet,

          ),



        ],


      ),


    );


  }





  Widget _paymentCard(

      String title,

      dynamic amount,

      IconData icon,

      ){



    return Container(


      margin:

      const EdgeInsets.only(
        bottom:16,
      ),



      padding:

      const EdgeInsets.all(20),



      decoration:

      BoxDecoration(

        color:

        Colors.white,

        borderRadius:

        BorderRadius.circular(20),


        boxShadow:[

          BoxShadow(

            color:

            Colors.grey.withValues(
              alpha:0.15,
            ),

            blurRadius:10,

            offset:

            const Offset(0,5),

          )

        ],


      ),



      child:

      Row(

        children:[


          CircleAvatar(

            radius:25,

            backgroundColor:

            const Color(
              0xFFE8F5E9,
            ),


            child:

            Icon(

              icon,

              color:

              const Color(
                0xFF2E7D32,
              ),

            ),

          ),



          const SizedBox(
            width:16,
          ),



          Expanded(

            child:

            Column(

              crossAxisAlignment:

              CrossAxisAlignment.start,


              children:[


                Text(

                  title,

                  style:

                  TextStyle(

                    color:

                    Colors.grey.shade600,

                  ),

                ),



                const SizedBox(
                  height:5,
                ),



                Text(

                  "₹${amount ?? 0}",

                  style:

                  const TextStyle(

                    fontSize:22,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),


              ],


            ),

          )

        ],

      ),


    );


  }


}