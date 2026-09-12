import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/localization/language_controller.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(
    AnimatedBuilder(
      animation: languageController,
      builder: (context, child) {
        return FarmoraApp(
          locale: languageController.locale,
        );
      },
    ),
  );
}

class FarmoraApp extends StatelessWidget {
  final Locale locale;

  const FarmoraApp({
    super.key,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farmora',
      locale: locale,

      supportedLocales: const [
        Locale('en'),
        Locale('ta'),
        Locale('mr'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: AppTheme.lightTheme,

      home: const SplashScreen(),
    );
  }
}