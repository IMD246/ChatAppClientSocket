import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/constant.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  final SharedPreferences sharedPref;
  ThemeProvider({required this.sharedPref}) {
    _init();
  }
  bool get isDarkMode => themeMode == ThemeMode.dark;

  Future<void> toggleTheme({required bool isOn, required String userID}) async {
    final response = await sharedPref.setBool(Constants.themeKey, isOn);
    if (response) {
      themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  _init() {
    final isDarkMode = sharedPref.getBool(Constants.themeKey);
    if (isDarkMode != null) {
      themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    } else {
      themeMode = ThemeMode.system;
    }
  }

  setThemeData({required bool? isDarkMode}) {
    if (isDarkMode != null) {
      themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    } else {
      themeMode = ThemeMode.system;
    }
    notifyListeners();
  }
}
