import 'package:flutter/material.dart';
import 'package:lifetrack/design_system/components/glass_card.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';

/// Wraps metric section content with theme surface and defined spacing scale.
/// Use for dashboard metric blocks (e.g. today summary, vitals summary).
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );
  }
}
