import 'package:flutter/material.dart';
import 'package:lifetrack/design_system/components/glass_card.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';
import 'package:lifetrack/domain/education/models/pioneer.dart';

class PioneerCard extends StatelessWidget {
  const PioneerCard({required this.pioneer, super.key});

  final Pioneer pioneer;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(radius: 24, backgroundImage: AssetImage(pioneer.imageAsset)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pioneer.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: AppSpacing.xs),
                Text(pioneer.contribution),
                const SizedBox(height: AppSpacing.xs),
                Text('Why it matters: ${pioneer.relevance}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
