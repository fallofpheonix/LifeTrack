import 'package:flutter/material.dart';
import 'package:lifetrack/design_system/components/glass_card.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';
import 'package:lifetrack/domain/education/models/research_item.dart';

class ResearchCard extends StatelessWidget {
  const ResearchCard({required this.item, super.key});

  final ResearchItem item;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(item.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.sm),
          Text(item.impact),
          const SizedBox(height: AppSpacing.sm),
          Chip(
            visualDensity: VisualDensity.compact,
            label: Text(item.source, style: Theme.of(context).textTheme.labelSmall),
          ),
        ],
      ),
    );
  }
}
