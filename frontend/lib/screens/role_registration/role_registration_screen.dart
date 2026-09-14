import 'package:flutter/material.dart';

import '../farmer/farmer_registration_screen.dart';
import '../fpo/fpo_registration_screen.dart';
import '../buyer/buyer_registration_screen.dart';


class RoleRegistrationScreen extends StatelessWidget {
  const RoleRegistrationScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Role Registration",
        ),
      ),


      body: Padding(

        padding: const EdgeInsets.all(24),


        child: Column(

          children: [


            _roleButton(
              context,
              "Farmer Registration",
              const FarmerRegistrationScreen(),
            ),


            const SizedBox(height:16),


            _roleButton(
              context,
              "FPO Registration",
              const FpoRegistrationScreen(),
            ),


            const SizedBox(height:16),


            _roleButton(
              context,
              "Buyer Registration",
              const BuyerRegistrationScreen(),
            ),


          ],

        ),

      ),

    );

  }



  Widget _roleButton(
      BuildContext context,
      String title,
      Widget page,
      ) {


    return SizedBox(

      width: double.infinity,

      height: 55,


      child: ElevatedButton(

        onPressed: () {


          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder: (_) => page,

            ),

          );


        },


        child: Text(title),

      ),

    );

  }

}