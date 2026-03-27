import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Header theme colors (configurable per company)
  static const Color headerOrange = Color(0xFFE8622A);
  static const Color headerBlue = Color(0xFF2563EB);
  static const Color headerGreen = Color(0xFF16A34A);
  static const Color headerTeal = Color(0xFF0D9488);

  // Status colors
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusApproved = Color(0xFF10B981);
  static const Color statusSentReview = Color(0xFF3B82F6);
  static const Color statusRejected = Color(0xFFEF4444);
  static const Color statusNew = Color(0xFF8B5CF6);

  // UI Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color iconBackground = Color(0xFFF3F4F6);

  // Icon/action colors
  static const Color iconBlue = Color(0xFF3B82F6);
  static const Color iconOrange = Color(0xFFF97316);
  static const Color iconGreen = Color(0xFF10B981);
  static const Color iconPurple = Color(0xFF8B5CF6);
  static const Color iconRed = Color(0xFFEF4444);
  static const Color iconTeal = Color(0xFF14B8A6);
  static const Color iconYellow = Color(0xFFF59E0B);
  static const Color dangerRed = Color(0xFFEF4444);

  // Dashboard design tokens (reference-matched)
  static const Color dashboardAccent = Color(0xFFFC5A2A);
  static const Color dashboardAccentDark = Color(0xFFE74A1E);
  static const Color dashboardAccentSoft = Color(0xFFFFEEE7);
  static const Color dashboardCardFill = Color(0xFFFFFFFF);
  static const Color dashboardCardShadow = Color(0x14000000);
}

class AppTheme {
  static const LinearGradient dashboardHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.dashboardAccent, AppColors.dashboardAccentDark],
  );

  static TextTheme get _textTheme => GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          displayMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          bodyLarge: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          bodyMedium: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          bodySmall: TextStyle(fontSize: 12, color: AppColors.textMuted),
          labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.headerOrange,
        secondary: AppColors.headerBlue,
        surface: AppColors.cardBackground,
      ),
      textTheme: _textTheme,
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(elevation: 0),
      dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.headerOrange, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
