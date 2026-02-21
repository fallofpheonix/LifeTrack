import 'package:flutter/material.dart';
import 'package:lifetrack/design_system/components/glass_card.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';
import 'package:lifetrack/domain/education/models/mock_health_record.dart';

class RecordCard extends StatelessWidget {
  const RecordCard({required this.record, super.key});

  final MockHealthRecord record;

  @override
  Widget build(BuildContext context) {
    final Color trendColor = record.isUp ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.error;
    return GlassCard(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(record.metric, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.xs),
                Text(record.value),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Icon(record.isUp ? Icons.arrow_upward : Icons.arrow_downward, color: trendColor, size: 14),
              const SizedBox(width: AppSpacing.xs),
              Text(record.time, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
