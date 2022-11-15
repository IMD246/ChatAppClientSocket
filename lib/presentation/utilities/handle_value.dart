import 'package:flutter/material.dart';
import 'package:testsocketchatapp/presentation/enum/enum.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';

class UtilHandleValue {
  static String getLanguage(String language, BuildContext context) {
    if (language.compareTo("vi") == 0) {
      return context.loc.vietnamese;
    } else if (language.compareTo("en") == 0) {
      return context.loc.english;
    } else {
      return "";
    }
  }

  static String getFullLocale(Locale locale) {
    return "${locale.languageCode}_${locale.countryCode}";
  }

  static String setStatusMessageText(
      String messageStatus, BuildContext context) {
    if (messageStatus.toLowerCase() == MessageStatus.sent.name.toLowerCase()) {
      return context.loc.sent;
    }
    else if (messageStatus.toLowerCase() == MessageStatus.viewed.name.toLowerCase()) {
      return context.loc.viewed;
    }
    else
    {
      return context.loc.not_sent;
    }
  }

   static bool isDarkMode(ThemeMode themeMode) {
    return themeMode == ThemeMode.dark ? true : false;
  }
}
