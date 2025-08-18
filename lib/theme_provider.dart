import 'package:flutter/material.dart';
import 'package:gymatvendor/core/utils/preferences.dart';

class ThemeProvider with ChangeNotifier{
  bool isDarkMode = false;
  Preferences preferences = Preferences();
  void changeDarkMode(){
    bool isDarkMode = preferences.isDarkMode();
    preferences.saveIsDarkMode(!isDarkMode);
    this.isDarkMode = !isDarkMode;
    notifyListeners();
  }
}