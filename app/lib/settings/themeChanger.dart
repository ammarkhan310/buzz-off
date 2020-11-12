//followed tutorial by Parth Patel
//https://www.c-sharpcorner.com/article/dynamic-theme-in-flutter-using-provider/
import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  bool darkMode = false;
  getDarkMode() => this.darkMode;
  void makeDark(darkMode) {
    this.darkMode = darkMode;
    notifyListeners();
  }
}
