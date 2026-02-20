import 'package:flutter/material.dart';

class AppTheme {
  // Clinical palette
  static const Color appPrimary = Color(0xFF2F4858);
  static const Color appAccent = Color(0xFF6FA3A9);
  static const Color appBackgroundLight = Color(0xFFF4F7F8);
  static const Color appBackgroundDark = Color(0xFF1C2328);

  // Semantic surfaces
  static const Color cardSurfaceLight = Color(0xFFFFFFFF);
  static const Color cardSurfaceDark = Color(0xFF242D33);

  static ThemeData get lightTheme {
    const ColorScheme scheme = ColorScheme.light(
      primary: appPrimary,
      secondary: appAccent,
      tertiary: Color(0xFF5C8C91),
      surface: cardSurfaceLight,
      onSurface: Color(0xFF1F2A33),
      onPrimary: Colors.white,
      onSecondary: Color(0xFF102028),
      primaryContainer: Color(0xFFDCE8EA),
      secondaryContainer: Color(0xFFE5F0F1),
      outlineVariant: Color(0xFFCCD7DC),
      error: Color(0xFFB3261E),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: appBackgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        elevation: 1.4,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
      secondary: Color(0xFF7EB0B4),
      tertiary: Color(0xFF8FC3C8),
      surface: cardSurfaceDark,
      onSurface: Color(0xFFD5E0E4),
      onPrimary: Color(0xFF0E1A21),
      onSecondary: Color(0xFF102028),
      primaryContainer: Color(0xFF31444D),
      secondaryContainer: Color(0xFF2A3B43),
      outlineVariant: Color(0xFF3B4A52),
      error: Color(0xFFF2B8B5),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
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
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.42)),
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
