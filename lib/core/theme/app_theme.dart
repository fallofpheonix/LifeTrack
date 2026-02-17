import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4DB6AC), // Lighter Teal for dark mode
        secondary: Color(0xFF80CBC4),
        surface: Color(0xFF1E1E1E),
        error: Color(0xFFCF6679),
        onPrimary: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Color(0xFFE0F2F1),
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: Color(0xFFB2DFDB)),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 0,
        shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(20),
           side: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        margin: const EdgeInsets.only(bottom: 12),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFFE0F2F1), letterSpacing: -0.5),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFFE0F2F1)),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFB2DFDB)),
        bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFFB0BEC5)),
        bodySmall: TextStyle(fontSize: 12, color: Color(0xFF78909C)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF4DB6AC), width: 1.5),
        ),
        labelStyle: const TextStyle(color: Color(0xFF78909C)),
        prefixIconColor: const Color(0xFF78909C),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF4DB6AC)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4DB6AC),
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF4DB6AC),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        indicatorColor: const Color(0xFF4DB6AC).withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: Color(0xFF4DB6AC), fontWeight: FontWeight.w700);
          }
          return const TextStyle(color: Color(0xFF78909C), fontWeight: FontWeight.w500);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
           if (states.contains(WidgetState.selected)) {
             return const IconThemeData(color: Color(0xFF4DB6AC));
           }
           return const IconThemeData(color: Color(0xFF78909C));
        }),
      ),
      useMaterial3: true,
    );
  }
}
