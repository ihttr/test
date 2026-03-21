import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryGold = Color(0xFFD4A843);
  static const Color primaryGoldLight = Color(0xFFE8C46A);
  static const Color primaryGoldDark = Color(0xFFAA8030);

  // Dark Theme Colors
  static const Color darkBg = Color(0xFF0D0F14);
  static const Color darkSurface = Color(0xFF161A22);
  static const Color darkCard = Color(0xFF1E2330);
  static const Color darkCardLight = Color(0xFF252B3B);
  static const Color darkText = Color(0xFFF0F2F8);
  static const Color darkTextSecondary = Color(0xFF8B92A8);

  // Light Theme Colors
  static const Color lightBg = Color(0xFFF5F7FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardAlt = Color(0xFFF0F3FF);
  static const Color lightText = Color(0xFF0D1020);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    colorScheme: const ColorScheme.dark(
      primary: primaryGold,
      secondary: primaryGoldLight,
      surface: darkSurface,
      onPrimary: darkBg,
      onSurface: darkText,
    ),
    textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.cairo(
        color: darkText,
        fontSize: 48,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.cairo(
        color: darkText,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.cairo(
        color: darkText,
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.cairo(
        color: darkTextSecondary,
        fontSize: 14,
      ),
    ),
    cardTheme: CardTheme(
      color: darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkBg,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cairo(
        color: darkText,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: darkText),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryGold;
        return darkTextSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryGold.withOpacity(0.3);
        return darkCard;
      }),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBg,
    colorScheme: const ColorScheme.light(
      primary: primaryGold,
      secondary: primaryGoldLight,
      surface: lightSurface,
      onPrimary: lightText,
      onSurface: lightText,
    ),
    textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.cairo(
        color: lightText,
        fontSize: 48,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.cairo(
        color: lightText,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.cairo(
        color: lightText,
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.cairo(
        color: lightTextSecondary,
        fontSize: 14,
      ),
    ),
    cardTheme: CardTheme(
      color: lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: Colors.black.withOpacity(0.08),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightBg,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cairo(
        color: lightText,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: lightText),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryGold;
        return lightTextSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryGold.withOpacity(0.3);
        return lightCardAlt;
      }),
    ),
  );
}
