import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testsocketchatapp/constants/constant.dart';

class LanguageProvider extends ChangeNotifier {
  late Locale locale;
  final SharedPreferences sharedPref;
  LanguageProvider(this.sharedPref) {
    _init();
  }
  Future<void> changeLocale(
      {required String language, required String userID}) async {
    final value =
        await sharedPref.setString(Constants.languageKey, language);
    if (value) {
      setLocale(language: language);
    }
  }

  _init() {
    final language = sharedPref.getString(Constants.languageKey);
    if (language == null) {
      locale = Locale(Platform.localeName);
    } else {
      final splitLanguage = language.split("_");
      locale = Locale(splitLanguage[0], splitLanguage[1]);
    }
  }

  void setLocale({required String language}) {
    final splitLanguage = language.split("_");
    locale = Locale(splitLanguage[0], splitLanguage[1]);
    notifyListeners();
  }
}
