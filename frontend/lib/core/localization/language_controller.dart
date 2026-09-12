import 'package:flutter/material.dart';

class LanguageController extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}

final languageController = LanguageController();