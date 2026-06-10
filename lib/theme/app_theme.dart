import 'package:flutter/material.dart';

class AppTheme {
  // Cores principais baseadas no design
  static const Color background = Color(0xFFF5EFE6);
  static const Color surface = Color(0xFFEDE4D5);
  static const Color primary = Color(0xFF6B2D3E);       // vinho/bordô
  static const Color primaryLight = Color(0xFF9C4A5A);
  static const Color textDark = Color(0xFF2C1A22);
  static const Color textMedium = Color(0xFF6B5560);
  static const Color textLight = Color(0xFFB8A8B0);
  static const Color cardBg = Color(0xFFEDE4D5);
  static const Color inputBg = Color(0xFFF0E8DA);
  static const Color divider = Color(0xFFD4C5B8);

  // Cores das categorias
  static const Color catFamily = Color(0xFFE8A0A0);
  static const Color catFood = Color(0xFFB5D5A0);
  static const Color catTravel = Color(0xFFA0C4E8);
  static const Color catNature = Color(0xFFD4B8E0);
  static const Color catParty = Color(0xFFF0D080);
  static const Color catWork = Color(0xFFE0C4A0);
  static const Color catPersonal = Color(0xFFA0D4C8);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        fontFamily: 'serif',
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
}