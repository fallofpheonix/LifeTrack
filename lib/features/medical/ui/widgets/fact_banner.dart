import 'package:flutter/material.dart';
import 'package:lifetrack/design_system/components/glass_card.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';

class FactBanner extends StatelessWidget {
  const FactBanner({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
