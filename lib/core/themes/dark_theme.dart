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
  );
}
