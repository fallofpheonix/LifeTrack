import 'package:flutter/material.dart';
import 'package:lifetrack/core/theme/app_colors_extension.dart';

class AppTheme {
  // Dark-violet glass palette
  static const Color appPrimary = Color(0xFF191735);
  static const Color appAccent = Color(0xFF9A7BFF);
  static const Color appAccentSoft = Color(0xFF6A5CD8);
  static const Color appBackgroundLight = Color(0xFFF4F7F8);
  static const Color appBackgroundDark = Color(0xFF141227);

  // Semantic surfaces
  static const Color cardSurfaceLight = Color(0xE6FFFFFF);
  static const Color cardSurfaceDark = Color(0x22FFFFFF);

  static ThemeData get lightTheme {
    const ColorScheme scheme = ColorScheme.light(
      primary: appPrimary,
      secondary: appAccent,
      tertiary: appAccentSoft,
      surface: cardSurfaceLight,
      onSurface: Color(0xFF1D1C2F),
      onPrimary: Colors.white,
      onSecondary: Color(0xFF17142B),
      primaryContainer: Color(0xFFE5E0FF),
      secondaryContainer: Color(0xFFEEEAFE),
      outlineVariant: Color(0xFFD8D3EA),
      error: Color(0xFFB3261E),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      extensions: const <ThemeExtension<dynamic>>[AppColors.light],
      colorScheme: scheme,
      scaffoldBackgroundColor: appBackgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        shadowColor: appPrimary.withValues(alpha: 0.10),
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.55)),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.3),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14, height: 1.45),
        bodySmall: TextStyle(fontSize: 12),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurface.withValues(alpha: 0.48),
        type: BottomNavigationBarType.fixed,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.secondaryContainer,
        selectedColor: scheme.primaryContainer,
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  static ThemeData get darkTheme {
    const ColorScheme scheme = ColorScheme.dark(
      primary: appAccent,
      secondary: appAccentSoft,
      tertiary: Color(0xFFC6B7FF),
      surface: cardSurfaceDark,
      onSurface: Color(0xFFEAE8FF),
      onPrimary: Color(0xFF17142B),
      onSecondary: Color(0xFFEAE8FF),
      primaryContainer: Color(0xFF2A2459),
      secondaryContainer: Color(0xFF1F1C3F),
      outlineVariant: Color(0x664B4378),
      error: Color(0xFFF2B8B5),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      extensions: const <ThemeExtension<dynamic>>[AppColors.dark],
      colorScheme: scheme,
      scaffoldBackgroundColor: appBackgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.3),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14, height: 1.45),
        bodySmall: TextStyle(fontSize: 12),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurface.withValues(alpha: 0.52),
        type: BottomNavigationBarType.fixed,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.secondaryContainer,
        selectedColor: scheme.primaryContainer,
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.55)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(fontSize: 12),
      ),
    );
  }
}
