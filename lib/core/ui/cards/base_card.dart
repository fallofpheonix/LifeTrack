import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const BaseCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Theme-aware styling
    final theme = Theme.of(context);
    final cardColor = backgroundColor ?? theme.cardTheme.color;
    
    return Container(
      margin: theme.cardTheme.margin,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: theme.brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null, // No shadow in dark mode, usually relies on border or surface color
        border: theme.brightness == Brightness.dark
            ? Border.all(color: Colors.white.withValues(alpha: 0.05))
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
