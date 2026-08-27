import 'package:flutter/material.dart';

ThemeData getDarkMode(Color seedColor) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    fontFamily: 'Raleway',

    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
      primary: seedColor,
      surface: const Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF121212),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: seedColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),

      titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),

      bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),

      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),

      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    ),
  );
}
