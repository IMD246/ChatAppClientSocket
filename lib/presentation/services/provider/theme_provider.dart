// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:testsocketchatapp/data/repositories/theme_repository.dart';
import 'package:testsocketchatapp/presentation/utilities/validate.dart';


class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  final ThemeModeRepository themeModeRepository;
  ThemeProvider({
    required this.themeModeRepository,
  });
  bool get isDarkMode => themeMode == ThemeMode.dark;

  Future<void> toggleTheme({required bool isOn, required String userID}) async {
    final value = await themeModeRepository.getData(
        body: {"userID": userID, "isDarkMode": isOn},
        urlAPI: themeModeRepository.themeModeURL,
        headers: {"Content-Type": "application/json"});
    if (ValidateUtilities.checkBaseResponse(baseResponse: value)) {
      themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
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