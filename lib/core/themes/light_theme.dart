import 'package:flutter/material.dart';

ThemeData getLightMode(Color seedColor) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F7F9),
    fontFamily: 'Raleway',

    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      primary: seedColor,
      surface: Colors.white,
      onSurface: const Color(0xFF2D3436),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFF5F7F9),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: seedColor,
        fontSize: 17,
        fontWeight: FontWeight.bold,
        fontFamily: 'Raleway',
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
