import 'package:flutter/material.dart';
import 'package:lifetrack/design_system/components/glass_card.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';
import 'package:lifetrack/domain/education/models/disease.dart';

class DiseaseCard extends StatelessWidget {
  const DiseaseCard({required this.disease, super.key});

  final Disease disease;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(disease.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.sm),
          Text(disease.desc),
          const SizedBox(height: AppSpacing.sm),
          Text('Prevention: ${disease.prevention}'),
          const SizedBox(height: AppSpacing.xs),
          Text('Risk Group: ${disease.risk}', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
