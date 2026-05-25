import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFF5EFE6);
  static const Color surface = Color(0xFFEDE4D5);
  static const Color primary = Color(0xFF6B2D3E);
  static const Color primaryLight = Color(0xFF9C4A5A);
  static const Color textDark = Color(0xFF2C1A22);
  static const Color textMedium = Color(0xFF6B5560);
  static const Color textLight = Color(0xFFB8A8B0);
  static const Color cardBg = Color(0xFFEDE4D5);
  static const Color inputBg = Color(0xFFF0E8DA);
  static const Color divider = Color(0xFFD4C5B8);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(
      primary: primary,
      surface: surface,
      onPrimary: Colors.white,
      onSurface: textDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: textLight, fontSize: 14),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding:
        const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );
}