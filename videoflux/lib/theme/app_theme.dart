import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const bg = Color(0xFF0F0F14);
  static const surface = Color(0xFF17171F);
  static const surface2 = Color(0xFF1E1E28);
  static const surface3 = Color(0xFF252530);

  // Accent
  static const accent = Color(0xFF7C6FF7);
  static const accent2 = Color(0xFFA855F7);
  static const accentGlow = Color(0x2E7C6FF7);

  // Semantic
  static const green = Color(0xFF22C55E);
  static const amber = Color(0xFFF59E0B);
  static const red = Color(0xFFEF4444);

  // Text
  static const text = Color(0xFFF1F0FF);
  static const text2 = Color(0xFF9897B0);
  static const text3 = Color(0xFF5C5B72);

  // Border
  static const border = Color(0x12FFFFFF);
  static const border2 = Color(0x1FFFFFFF);

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accent2],
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accent2,
        surface: AppColors.surface,
        onPrimary: Colors.white,
        onSurface: AppColors.text,
      ),
      fontFamily: 'DMSans',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text,
        ),
        titleSmall: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text,
        ),
        bodyLarge: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.text,
        ),
        bodyMedium: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.text2,
        ),
        bodySmall: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.text3,
        ),
        labelLarge: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text, letterSpacing: 0.2,
        ),
        labelSmall: TextStyle(
          fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.text3, letterSpacing: 0.8,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.text3, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.text2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'SpaceGrotesk',
          ),
        ),
      ),
      dividerColor: AppColors.border,
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 0.5,
        space: 0,
      ),
    );
  }
}
