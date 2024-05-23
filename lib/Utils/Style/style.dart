import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    print("isDark Theme $isDarkTheme");
    return ThemeData(
      primaryColor: isDarkTheme ? Colors.black54 : Colors.white,
      indicatorColor: isDarkTheme ? Colors.black54 : const Color(0xffCBDCF8),
      hintColor: isDarkTheme ? Colors.black54 : const Color(0xffEECED3),
      hoverColor: isDarkTheme ? Colors.black54 : const Color(0xff4285F4),
      focusColor: isDarkTheme ? Colors.black54 : const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      textTheme: Theme.of(context).textTheme.copyWith(
            titleLarge: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black54,
              fontSize: 16.0, // You can adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
            displayLarge: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black54,
              fontSize: 10.0, // You can adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
            displayMedium: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black54,
              fontSize: 14.0, // You can adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black54,
              fontSize: 12.0, // You can adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black54,
              fontSize: 15.0, // You can adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
          ),
      cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black54 : Colors.grey[50],
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkTheme ? Colors.white : Colors.black54), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
          .copyWith(background: isDarkTheme ? Colors.black54 : Colors.white).copyWith(background: isDarkTheme ? Colors.black54 : Colors.white),
    );
  }
}
