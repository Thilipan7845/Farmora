import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
//import 'core/localization/language_controller.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();


await Supabase.initialize(
  url: SupabaseConfig.url,
  publishableKey: SupabaseConfig.publishableKey,
);

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


      title: "Farmora",


      theme: AppTheme.lightTheme,


      localizationsDelegates: const [

        GlobalMaterialLocalizations.delegate,

        GlobalWidgetsLocalizations.delegate,

        GlobalCupertinoLocalizations.delegate,

      ],


      supportedLocales: const [

        Locale("en"),

      ],


      home: const SplashScreen(),

    );

  }

  }