import 'package:flutter/material.dart';
import 'package:lifetrack/design_system/components/glass_card.dart';
import 'package:lifetrack/design_system/motion/app_motion.dart';
import 'package:lifetrack/design_system/tokens/app_radius.dart';

class BaseCard extends StatefulWidget {
  const BaseCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  State<BaseCard> createState() => _BaseCardState();
}

class _BaseCardState extends State<BaseCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: AppMotion.cardPress,
      curve: AppMotion.standardCurve,
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _scale = 0.992),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTapUp: (_) => setState(() => _scale = 1.0),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: GlassCard(
          padding: widget.padding ?? const EdgeInsets.all(16),
          child: widget.child,
          ),
      ),
    );
  }
}
