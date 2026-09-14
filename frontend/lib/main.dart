import 'package:flutter/material.dart';
import 'screens/fpo/fpo_dashboard.dart';


void main() {

  runApp(
    const FarmoraApp(),
  );

}



class FarmoraApp extends StatelessWidget {

  const FarmoraApp({
    super.key,
  });



  @override
  Widget build(BuildContext context) {


    return MaterialApp(

      debugShowCheckedModeBanner: false,


      title: 'Farmora',



      theme: ThemeData(

        useMaterial3: true,


        colorScheme: ColorScheme.fromSeed(

          seedColor: const Color(0xff315C38),

        ),


        scaffoldBackgroundColor:

        const Color(0xffF6F7F2),



        appBarTheme: const AppBarTheme(

          elevation: 0,

          backgroundColor: Colors.transparent,

          foregroundColor: Colors.black,

        ),


      ),



      home: const FpoDashboard(),


    );


  }

}