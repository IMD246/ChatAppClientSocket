import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/constant.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appbarTheme(
      context: context,
      color: Colors.black.withOpacity(
        0.7,
      ),
    ),
    iconTheme: const IconThemeData(color: kContentColorLightTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
        bodyColor: kContentColorLightTheme,
        displayColor: kContentColorLightTheme),
    colorScheme: const ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      suffixIconColor: Colors.black.withOpacity(0.7),
      suffixStyle: TextStyle(
        color: Colors.black.withOpacity(0.7),
      ),
      prefixIconColor: Colors.black.withOpacity(0.7),
    ),
    primaryTextTheme:
        const TextTheme(headline6: TextStyle(color: kContentColorLightTheme)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  // Bydefault flutter provie us light and dark theme
  // we just modify it as our need
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorLightTheme,
    appBarTheme: appbarTheme(context: context, color: Colors.white60),
    iconTheme: const IconThemeData(color: kContentColorDarkTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
        bodyColor: kContentColorDarkTheme,
        displayColor: kContentColorDarkTheme),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      suffixIconColor: Colors.white70,
      suffixStyle: TextStyle(color: Colors.white70),
      prefixIconColor: Colors.white70,
    ),
    primaryTextTheme: const TextTheme(
      headline6: TextStyle(
        color: kContentColorDarkTheme,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kContentColorLightTheme,
      selectedItemColor: Colors.white70,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: Colors.white70),
      showUnselectedLabels: true,
    ),
  );
}

AppBarTheme appbarTheme({required BuildContext context, required Color color}) {
  final appBarTheme = AppBarTheme(
    backgroundColor: kPrimaryColor,
    actionsIconTheme: IconThemeData(
      color: color,
    ),
    iconTheme: IconThemeData(
      color: color,
    ),
    foregroundColor: color,
  );
  return appBarTheme;
}
