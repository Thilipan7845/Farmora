import 'package:flutter/material.dart';


class FpoDashboard extends StatefulWidget {

  const FpoDashboard({super.key});

  @override
  State<FpoDashboard> createState() => _FpoDashboardState();

}



class _FpoDashboardState extends State<FpoDashboard> {


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



            // FPO HEADER CARD

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


                  const SizedBox(height: 8),


                  const Text(

                    "AI Powered Farming • Smart Markets • Better Profits",

                    style: TextStyle(

                      color: Colors.white70,

                      fontSize: 14,

                    ),

                  ),



                  const SizedBox(height: 25),



                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,


                    children: [


                      statBox(
                        "250+",
                        "Farmers",
                      ),


                      statBox(
                        "12.5T",
                        "Produce",
                      ),


                      statBox(
                        "38",
                        "Buyers",
                      ),


                    ],

                  )


                ],

              ),

            ),



            const SizedBox(height:20),




            dashboardCard(

              title: "🤖 AI Market Intelligence",

              children: [


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
                  "HOLD for better profit",
                ),


              ],

            ),



            const SizedBox(height:20),



            dashboardCard(

              title: "🌱 Crop Collection",

              children: [


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

              title: "🤝 Smart Buyer Matching",

              children: [


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

            ),const SizedBox(height: 20),

            // SMART OPERATIONS
            dashboardCard(
              title: "🌦 Smart Operations & AI Insights",
              children: [
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

            const SizedBox(height: 20),

            // ORDER TRACKING
            dashboardCard(
              title: "🚚 Order Tracking",
              children: [
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

            const SizedBox(height: 20),

            // FPO PERFORMANCE
            dashboardCard(
              title: "📊 FPO Performance",
              children: [
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

            const SizedBox(height: 25),

            // QUICK ACTIONS
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xff173B1A),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: quickAction(
                    Icons.people_alt_rounded,
                    "Members",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: quickAction(
                    Icons.agriculture_rounded,
                    "Produce",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: quickAction(
                    Icons.handshake_rounded,
                    "Buyers",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: quickAction(
                    Icons.local_shipping_rounded,
                    "Orders",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // FOOTER
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.eco_rounded,
                    color: Color(0xff388E3C),
                    size: 30,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Powered by Farmora Intelligence",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  // STAT BOX
  Widget statBox(
    String value,
    String label,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }


  // DASHBOARD CARD
  Widget dashboardCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff214D26),
            ),
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }


  // INFORMATION ROW
  Widget infoRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xff1B5E20),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // CROP TILE
  Widget cropTile(
    String crop,
    String quantity,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xffF5F8F3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.12),
            child: Icon(
              Icons.eco_rounded,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              crop,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            quantity,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff1B5E20),
            ),
          ),
        ],
      ),
    );
  }


  // BUYER CARD
  Widget buyerCard(
    String name,
    String requirement,
    String match,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffF5F8F3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: const Color(0xffDCEFD8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.business_rounded,
              color: Color(0xff2E7D32),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  requirement,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffE1F3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              match,
              style: const TextStyle(
                color: Color(0xff2E7D32),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ORDER TILE
  Widget orderTile(
    String orderId,
    String description,
    String status,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffF7F9F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: const Color(0xffE7F1E5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.local_shipping_rounded,
              color: Color(0xff2E7D32),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // PERFORMANCE TILE
  Widget performanceTile(
    String title,
    String value,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xffF5F8F3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.trending_up_rounded,
            color: Color(0xff2E7D32),
            size: 30,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1B5E20),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // QUICK ACTION
  Widget quickAction(
    IconData icon,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xff2E7D32),
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xff214D26),
            ),
          ),
        ],
      ),
    );
  }
}