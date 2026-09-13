import 'package:flutter/material.dart';

import '../../services/order_service.dart';



class OrdersScreen extends StatefulWidget {


  const OrdersScreen({
    super.key,
  });



  @override
  State<OrdersScreen> createState() =>
      _OrdersScreenState();

}



class _OrdersScreenState
    extends State<OrdersScreen> {


  bool loading = true;


  List<dynamic> orders = [];



  @override
  void initState(){

    super.initState();

    loadOrders();

  }




  Future<void> loadOrders() async {


    try{


      final data =
      await OrderService.getOrders();



      setState(() {

        orders=data;

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

          "My Orders",

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



      orders.isEmpty


      ?

      const Center(

        child:

        Text(

          "No orders found",

        ),

      )



      :



      ListView.builder(

        padding:

        const EdgeInsets.all(16),



        itemCount:

        orders.length,



        itemBuilder:(context,index){



          final order =
          orders[index];




          return Container(


            margin:

            const EdgeInsets.only(

              bottom:15,

            ),



            padding:

            const EdgeInsets.all(18),



            decoration:

            BoxDecoration(

              color: Colors.white,

              borderRadius:

              BorderRadius.circular(18),


              boxShadow:[


                BoxShadow(

                  color:

                  Colors.grey.withValues(

                    alpha:0.15,

                  ),

                  blurRadius:10,

                )

              ]

            ),



            child:Column(


              crossAxisAlignment:

              CrossAxisAlignment.start,



              children:[



                Text(

                  "Order #${order["id"]}",

                  style:

                  const TextStyle(

                    fontSize:18,

                    fontWeight:

                    FontWeight.bold,

                  ),

                ),



                const SizedBox(height:10),



                Text(

                  "Crop: ${order["crop_name"] ?? "Crop"}",

                ),



                Text(

                  "Quantity: ${order["quantity"] ?? 0} kg",

                ),



                Text(

                  "Amount: ₹${order["amount"] ?? 0}",

                ),



                const SizedBox(height:10),



                Container(

                  padding:

                  const EdgeInsets.symmetric(

                    horizontal:12,

                    vertical:6,

                  ),


                  decoration:

                  BoxDecoration(

                    color:

                    const Color(0xFFE8F5E9),

                    borderRadius:

                    BorderRadius.circular(20),

                  ),


                  child:Text(

                    order["status"] ??

                    "Pending",

                    style:

                    const TextStyle(

                      color:

                      Color(0xFF2E7D32),

                      fontWeight:

                      FontWeight.bold,

                    ),

                  ),

                ),


              ],

            ),

          );


        },

      ),


    );


  }


}