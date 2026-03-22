import 'package:flutter/material.dart';

class LanguageController extends ChangeNotifier {
  String selectedLanguage = "English";

  void changeLanguage(String lang) {
    selectedLanguage = lang;
    notifyListeners();
  }
}

LanguageController languageController = LanguageController();
