import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralised theme configuration for Quoted.
class AppTheme {
  AppTheme._();

  // ── Palette ────────────────────────────────────────────────────────────────
  static const Color _seedLight = Color(0xFF5C7A6B);
  static const Color _seedDark = Color(0xFF81B9A4);

  static const Color backgroundLight = Color(0xFFF8F5F0);
  static const Color backgroundDark = Color(0xFF1A1A1A);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF242424);

  static const Color onSurfaceLight = Color(0xFF1C1C1E);
  static const Color onSurfaceDark = Color(0xFFF0EDE8);

  static const Color subtleLight = Color(0xFF8A8A8E);
  static const Color subtleDark = Color(0xFF6E6E72);

  // ── Typography helpers ─────────────────────────────────────────────────────

  /// Serif font used for quote text (Lora).
  static TextStyle quoteTextStyle({
    required bool isDark,
    double fontSize = 22,
  }) =>
      GoogleFonts.lora(
        fontSize: fontSize,
        height: 1.55,
        fontStyle: FontStyle.italic,
        color: isDark ? onSurfaceDark : onSurfaceLight,
      );

  /// Author name style.
  static TextStyle authorStyle({required bool isDark}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: isDark ? subtleDark : subtleLight,
      );

  /// Small body / context text.
  static TextStyle bodyStyle({required bool isDark}) =>
      GoogleFonts.inter(
        fontSize: 14,
        height: 1.6,
        color: isDark ? onSurfaceDark.withAlpha(200) : onSurfaceLight.withAlpha(200),
      );

  // ── ThemeData ──────────────────────────────────────────────────────────────

  static ThemeData light() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedLight,
          brightness: Brightness.light,
        ).copyWith(
          surface: backgroundLight,
        ),
        scaffoldBackgroundColor: backgroundLight,
        cardTheme: CardTheme(
          color: surfaceLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: onSurfaceLight,
          ),
          iconTheme: const IconThemeData(color: onSurfaceLight),
        ),
        iconTheme: const IconThemeData(color: onSurfaceLight),
      );

  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedDark,
          brightness: Brightness.dark,
        ).copyWith(
          surface: backgroundDark,
        ),
        scaffoldBackgroundColor: backgroundDark,
        cardTheme: CardTheme(
          color: surfaceDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: onSurfaceDark,
          ),
          iconTheme: const IconThemeData(color: onSurfaceDark),
        ),
        iconTheme: const IconThemeData(color: onSurfaceDark),
      );
}
