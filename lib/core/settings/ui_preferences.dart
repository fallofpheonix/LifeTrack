import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UiPreferences {
  static bool reduceMotion = false;
  static const String _reduceMotionKey = 'ui_reduce_motion';

  static ThemeMode themeMode = ThemeMode.system;
  static const String _themeKey = 'ui_theme_mode';

  static Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    reduceMotion = prefs.getBool(_reduceMotionKey) ?? false;
    final int? themeIndex = prefs.getInt(_themeKey);
    if (themeIndex != null) {
      themeMode = ThemeMode.values[themeIndex];
    }
  }

  static Future<void> setReduceMotion(bool value) async {
    reduceMotion = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reduceMotionKey, value);
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }
}
