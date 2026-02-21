import 'package:flutter/material.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';

class ContentPadding extends StatelessWidget {
  const ContentPadding({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );
  }
}
