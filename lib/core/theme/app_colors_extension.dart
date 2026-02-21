import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.backgroundPrimary,
    required this.surfaceElevated,
    required this.surfaceSubtle,
    required this.accentActivity,
    required this.accentRecovery,
    required this.accentFocus,
    required this.textPrimary,
    required this.textSecondary,
  });

  final Color backgroundPrimary;
  final Color surfaceElevated;
  final Color surfaceSubtle;
  final Color accentActivity;
  final Color accentRecovery;
  final Color accentFocus;
  final Color textPrimary;
  final Color textSecondary;

  static const AppColors dark = AppColors(
    backgroundPrimary: Color(0xFF000000),
    surfaceElevated: Color(0x1FFFFFFF),
    surfaceSubtle: Color(0x14FFFFFF),
    accentActivity: Color(0xFF9A7BFF),
    accentRecovery: Color(0xFF5FD3BC),
    accentFocus: Color(0xFFFFC857),
    textPrimary: Color(0xFFF6F4FF),
    textSecondary: Color(0xFFB8B5C9),
  );

  static const AppColors light = AppColors(
    backgroundPrimary: Color(0xFFF4F6FB),
    surfaceElevated: Color(0xE6FFFFFF),
    surfaceSubtle: Color(0xCCFFFFFF),
    accentActivity: Color(0xFF5E3ED9),
    accentRecovery: Color(0xFF2A9E89),
    accentFocus: Color(0xFFB98100),
    textPrimary: Color(0xFF16142A),
    textSecondary: Color(0xFF5D5977),
  );

  @override
  AppColors copyWith({
    Color? backgroundPrimary,
    Color? surfaceElevated,
    Color? surfaceSubtle,
    Color? accentActivity,
    Color? accentRecovery,
    Color? accentFocus,
    Color? textPrimary,
    Color? textSecondary,
  }) {
    return AppColors(
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      accentActivity: accentActivity ?? this.accentActivity,
      accentRecovery: accentRecovery ?? this.accentRecovery,
      accentFocus: accentFocus ?? this.accentFocus,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      backgroundPrimary: Color.lerp(backgroundPrimary, other.backgroundPrimary, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      accentActivity: Color.lerp(accentActivity, other.accentActivity, t)!,
      accentRecovery: Color.lerp(accentRecovery, other.accentRecovery, t)!,
      accentFocus: Color.lerp(accentFocus, other.accentFocus, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}

extension AppColorsThemeX on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>() ?? AppColors.dark;
}
