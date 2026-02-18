import 'package:flutter/material.dart';

class AppTheme {
  // Semantic Colors
  static const Color _primaryTeal = Color(0xFF009688); // Teal 500
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _lightBackground = Color(0xFFF5F5F5); // Grey 100
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _errorColor = Color(0xFFB00020);



  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightBackground,
      colorScheme: const ColorScheme.light(
        primary: _primaryTeal,
        secondary: Color(0xFF00796B), // Teal 700
        surface: _lightSurface,
        onSurface: Colors.black87,
        error: _errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: const CardThemeData(
        color: _lightSurface,
        elevation: 2,
        shadowColor: Colors.black12,
        margin: EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryTeal,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 28, color: Colors.black87, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        titleLarge: TextStyle(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
        bodySmall: TextStyle(fontSize: 12, color: Colors.black45),
      ),
      iconTheme: const IconThemeData(color: _primaryTeal),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _lightSurface,
        selectedItemColor: _primaryTeal,
        unselectedItemColor: Colors.black26,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4DB6AC), // Teal 300 (Lighter for Dark Mode)
        secondary: Color(0xFF80CBC4),
        surface: _darkSurface,
        onSurface: Color(0xFFE0E0E0),
        error: Color(0xFFCF6679),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Color(0xFFE0E0E0)),
        titleTextStyle: TextStyle(
          color: Color(0xFFE0E0E0),
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: const CardThemeData(
        color: _darkSurface,
        elevation: 0,
        margin: EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Colors.white10), // Subtle border for contrast
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4DB6AC),
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 28, color: Color(0xFFE0E0E0), fontWeight: FontWeight.w800, letterSpacing: -0.5),
        titleLarge: TextStyle(fontSize: 22, color: Color(0xFFE0E0E0), fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 16, color: Color(0xFFB2DFDB), fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFB0BEC5), height: 1.5),
        bodySmall: TextStyle(fontSize: 12, color: Color(0xFF78909C)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF4DB6AC)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: Color(0xFF4DB6AC),
        unselectedItemColor: Colors.white24,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }
}

