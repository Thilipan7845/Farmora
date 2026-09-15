import 'package:flutter/material.dart';

import '../../services/intelligence_service.dart';


class FpoDashboard extends StatefulWidget {

  const FpoDashboard({super.key});


  @override
  State<FpoDashboard> createState() => _FpoDashboardState();

}



class _FpoDashboardState extends State<FpoDashboard> {


  Map<String, dynamic>? intelligenceData;

  bool isLoading = true;



  @override
  void initState() {

    super.initState();

    loadIntelligence();

  }



  Future<void> loadIntelligence() async {


    try {


      final response =
          await IntelligenceService.getDecision(

        {
          "crop": "cotton",
          "location": "Tamil Nadu",
        },

      );



      setState(() {


        intelligenceData = response;

        isLoading = false;


      });



    } catch (e) {


      setState(() {


        isLoading = false;


      });


    }


  }



  String getRecommendation() {


    if (intelligenceData == null) {

      return "Loading...";

    }



    return intelligenceData!["farmer_explanation"]
            ?["message_key"] ??
        "No recommendation";


  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: const Color(0xffF3F7F1),


      appBar: AppBar(

        backgroundColor: Colors.transparent,

        elevation: 0,

        centerTitle: true,


        title: const Text(

          "Farmora FPO Intelligence Hub",

          style: TextStyle(

            color: Color(0xff1B5E20),

            fontWeight: FontWeight.bold,

            fontSize: 20,

          ),

        ),

      ),



      body: SingleChildScrollView(


        padding: const EdgeInsets.all(16),


        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,


          children: [
                        Container(

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(

                gradient: const LinearGradient(

                  colors: [

                    Color(0xff1B5E20),

                    Color(0xff66BB6A),

                  ],

                  begin: Alignment.topLeft,

                  end: Alignment.bottomRight,

                ),

                borderRadius: BorderRadius.circular(28),

                boxShadow: const [

                  BoxShadow(

                    color: Colors.black12,

                    blurRadius: 12,

                    offset: Offset(0,5),

                  )

                ],

              ),


              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,


                children: [


                  const Text(

                    "🌾 Farmora Smart Agriculture FPO",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 23,

                      fontWeight: FontWeight.bold,

                    ),

                  ),


                  const SizedBox(height:8),


                  const Text(

                    "AI Powered Farming • Smart Markets • Better Profits",

                    style: TextStyle(

                      color: Colors.white70,

                      fontSize:14,

                    ),

                  ),


                  const SizedBox(height:25),


                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      statBox("250+", "Farmers"),

                      statBox("12.5T", "Produce"),

                      statBox("38", "Buyers"),

                    ],

                  )


                ],

              ),

            ),



            const SizedBox(height:20),



            dashboardCard(

              title:"🤖 AI Market Intelligence",

              children:[


                infoRow(

                  "Current Price",

                  "₹8,800",

                ),



                infoRow(

                  "Predicted Price",

                  "₹9,450",

                ),



                infoRow(

                  "Market Trend",

                  "📈 Rising",

                ),



                infoRow(

                  "AI Confidence",

                  "87%",

                ),



                infoRow(

                  "Recommendation",

                  getRecommendation(),

                ),


              ],

            ),



            const SizedBox(height:20),



            dashboardCard(

              title:"🌱 Crop Collection",

              children:[


                cropTile(

                  "Cotton",

                  "1200 Kg",

                  Colors.green,

                ),



                cropTile(

                  "Rice",

                  "800 Kg",

                  Colors.orange,

                ),



                cropTile(

                  "Tomato",

                  "450 Kg",

                  Colors.red,

                ),


              ],

            ),



            const SizedBox(height:20),



            dashboardCard(

              title:"🤝 Smart Buyer Matching",

              children:[


                buyerCard(

                  "ABC Agro Traders",

                  "Cotton 1000 Kg",

                  "92% Match",

                ),



                buyerCard(

                  "Fresh Market Pvt Ltd",

                  "Rice 500 Kg",

                  "86% Match",

                ),


              ],

            ),



            const SizedBox(height:20),



            dashboardCard(

              title:"🌦 Smart Operations & AI Insights",

              children:[


                infoRow(

                  "Weather Risk",

                  "🟢 Low Risk",

                ),



                infoRow(

                  "Storage Recommendation",

                  "Store Cotton for 10 Days",

                ),



                infoRow(

                  "Market Opportunity",

                  "🔥 High Rice Demand",

                ),



                infoRow(

                  "AI Savings Prediction",

                  "₹24,500 Benefit",

                ),


              ],

            ),



            const SizedBox(height:20),



            dashboardCard(

              title:"🚚 Order Tracking",

              children:[


                orderTile(

                  "#1024",

                  "Cotton → ABC Agro Traders",

                  "Transportation Started",

                  Colors.orange,

                ),



                orderTile(

                  "#1025",

                  "Rice → Fresh Market Pvt Ltd",

                  "Delivered",

                  Colors.green,

                ),


              ],

            ),



            const SizedBox(height:20),



            dashboardCard(

              title:"📊 FPO Performance",

              children:[


                performanceTile(

                  "Monthly Revenue",

                  "₹12.5 Lakhs",

                  "+24% growth",

                ),



                performanceTile(

                  "Sustainability Score",

                  "91%",

                  "Excellent performance",

                ),


              ],

            ),
                        const SizedBox(height:25),


            const Text(

              "Quick Actions",

              style: TextStyle(

                fontSize:21,

                fontWeight:FontWeight.bold,

                color:Color(0xff173B1A),

              ),

            ),


            const SizedBox(height:12),


            Row(

              children:[

                Expanded(

                  child:quickAction(

                    Icons.people_alt_rounded,

                    "Members",

                  ),

                ),


                const SizedBox(width:12),


                Expanded(

                  child:quickAction(

                    Icons.agriculture_rounded,

                    "Produce",

                  ),

                ),

              ],

            ),



            const SizedBox(height:12),



            Row(

              children:[

                Expanded(

                  child:quickAction(

                    Icons.handshake_rounded,

                    "Buyers",

                  ),

                ),


                const SizedBox(width:12),


                Expanded(

                  child:quickAction(

                    Icons.local_shipping_rounded,

                    "Orders",

                  ),

                ),

              ],

            ),



            const SizedBox(height:30),



            const Center(

              child:Text(

                "Powered by Farmora Intelligence",

                style:TextStyle(

                  color:Colors.black54,

                  fontSize:13,

                ),

              ),

            ),


          ],

        ),

      ),

    );

  }




  Widget statBox(String value,String label){

    return Column(

      children:[

        Text(

          value,

          style:const TextStyle(

            color:Colors.white,

            fontSize:22,

            fontWeight:FontWeight.bold,

          ),

        ),

        const SizedBox(height:4),


        Text(

          label,

          style:const TextStyle(

            color:Colors.white70,

            fontSize:12,

          ),

        ),

      ],

    );

  }





  Widget dashboardCard({

    required String title,

    required List<Widget> children,

  }){

    return Container(

      width:double.infinity,

      padding:const EdgeInsets.all(18),

      decoration:BoxDecoration(

        color:Colors.white,

        borderRadius:BorderRadius.circular(22),

        boxShadow:const [

          BoxShadow(

            color:Colors.black12,

            blurRadius:10,

            offset:Offset(0,4),

          )

        ],

      ),


      child:Column(

        crossAxisAlignment:CrossAxisAlignment.start,

        children:[

          Text(

            title,

            style:const TextStyle(

              fontSize:18,

              fontWeight:FontWeight.bold,

              color:Color(0xff214D26),

            ),

          ),


          const SizedBox(height:15),


          ...children,

        ],

      ),

    );

  }





  Widget infoRow(String title,String value){

    return Padding(

      padding:const EdgeInsets.symmetric(vertical:9),

      child:Row(

        mainAxisAlignment:MainAxisAlignment.spaceBetween,

        children:[

          Text(

            title,

            style:const TextStyle(

              color:Colors.black54,

              fontSize:14,

            ),

          ),


          Flexible(

            child:Text(

              value,

              textAlign:TextAlign.right,

              style:const TextStyle(

                color:Color(0xff1B5E20),

                fontWeight:FontWeight.bold,

                fontSize:14,

              ),

            ),

          ),

        ],

      ),

    );

  }





  Widget cropTile(String crop,String quantity,Color color){

    return Container(

      margin:const EdgeInsets.only(bottom:10),

      child:Row(

        children:[

          CircleAvatar(

            backgroundColor:color.withValues(alpha:.15),

            child:Icon(

              Icons.eco,

              color:color,

            ),

          ),


          const SizedBox(width:12),


          Text(

            crop,

            style:const TextStyle(

              fontWeight:FontWeight.bold,

            ),

          ),


          const Spacer(),


          Text(

            quantity,

            style:const TextStyle(

              fontWeight:FontWeight.bold,

            ),

          ),

        ],

      ),

    );

  }





  Widget buyerCard(String name,String requirement,String match){

    return ListTile(

      leading:const Icon(

        Icons.business,

        color:Color(0xff2E7D32),

      ),

      title:Text(name),

      subtitle:Text(requirement),

      trailing:Text(

        match,

        style:const TextStyle(

          fontWeight:FontWeight.bold,

        ),

      ),

    );

  }





  Widget orderTile(

      String id,

      String description,

      String status,

      Color color,

      ){

    return ListTile(

      leading:const Icon(Icons.local_shipping),

      title:Text(id),

      subtitle:Text(description),

      trailing:Text(

        status,

        style:TextStyle(

          color:color,

          fontWeight:FontWeight.bold,

        ),

      ),

    );

  }





  Widget performanceTile(

      String title,

      String value,

      String subtitle,

      ){

    return ListTile(

      title:Text(title),

      subtitle:Text(subtitle),

      trailing:Text(

        value,

        style:const TextStyle(

          fontWeight:FontWeight.bold,

        ),

      ),

    );

  }





  Widget quickAction(IconData icon,String title){

    return Container(

      padding:const EdgeInsets.all(18),

      decoration:BoxDecoration(

        color:Colors.white,

        borderRadius:BorderRadius.circular(18),

      ),

      child:Column(

        children:[

          Icon(

            icon,

            color:Color(0xff2E7D32),

          ),


          const SizedBox(height:8),


          Text(title),

        ],

      ),

    );

  }


}
