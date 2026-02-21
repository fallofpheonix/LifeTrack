import 'package:flutter/material.dart';
import 'package:lifetrack/design_system/tokens/app_colors.dart';
import 'package:lifetrack/design_system/tokens/app_radius.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderGlass),
      ),
      child: child,
    );
  }
}
