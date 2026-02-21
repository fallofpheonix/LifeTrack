import 'package:flutter/material.dart';
import 'package:lifetrack/core/theme/app_colors_extension.dart';

class RoundedActionButton extends StatelessWidget {
  const RoundedActionButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
  });

  static const double _radius = 18;
  static const double _vertical = 12;
  static const double _horizontal = 16;
  static const double _iconSize = 18;
  static const double _spacing = 8;

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(_radius),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_radius),
            color: c.surfaceSubtle,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: _vertical,
              horizontal: _horizontal,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: _iconSize, color: c.accentActivity),
                  const SizedBox(width: _spacing),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
