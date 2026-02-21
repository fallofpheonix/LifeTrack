import 'package:flutter/material.dart';
import 'package:lifetrack/design_system/tokens/app_colors.dart';

class GlassTheme {
  const GlassTheme._();

  static ThemeData applyTo(ThemeData base) {
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.bgPrimary,
        secondary: AppColors.accent,
      ),
    );
  }
}
