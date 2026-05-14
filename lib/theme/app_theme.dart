import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Color(0xFF111827),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFF6B7280),
      ),
    ),
  );
}