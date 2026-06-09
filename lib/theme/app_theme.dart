import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF4F6AF5);
  static const primaryLight = Color(0xFFEEF1FF);
  static const accent = Color(0xFFFF6B9D);
  static const accentOrange = Color(0xFFFF8C42);
  static const dark = Color(0xFF0F0F1A);
  static const surface = Color(0xFF1A1A2E);
  static const surfaceLight = Color(0xFF252540);
  static const cardBg = Color(0xFF1E1E35);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFAAAAAA);
  static const textMuted = Color(0xFF666680);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFB74D);
  static const gradientStart = Color(0xFF4F6AF5);
  static const gradientEnd = Color(0xFF8B5CF6);
}

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.dark,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2A2A4A), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintStyle: const TextStyle(color: AppColors.textMuted),
    ),
  );
}
