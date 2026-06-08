import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryViolet = Color(0xFF6A5AE0);
  static const Color slateMuted = Color(0xFF4A4E69);
  static const Color bgLight = Color(0xFFF8F9FA);
  static const Color cardDark = Color(0xFF1E1E26);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryViolet,
      scaffoldBackgroundColor: bgLight,
      colorScheme: const ColorScheme.light(
        primary: primaryViolet,
        secondary: slateMuted,
        surface: Colors.white,
        onSurface: Color(0xFF1A1A24),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryViolet,
      scaffoldBackgroundColor: const Color(0xFF0F0F14),
      colorScheme: const ColorScheme.dark(
        primary: primaryViolet,
        secondary: Color(0xFF9A8F97),
        surface: cardDark,
        onSurface: Color(0xFFE2E2E9),
      ),
      useMaterial3: true,
    );
  }
}