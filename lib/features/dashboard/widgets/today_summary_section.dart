import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/state/health_snapshot_provider.dart';
import 'package:lifetrack/core/theme/app_colors_extension.dart';
import 'package:lifetrack/design_system/components/metric_card.dart';
import 'package:lifetrack/design_system/components/metric_item.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';

class TodaySummarySection extends ConsumerWidget {
  const TodaySummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(healthSnapshotProvider);
    final c = context.appColors;

    return MetricCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MetricItem(
                label: 'Steps',
                value: snapshot.steps.toString(),
                icon: Icons.directions_walk,
                color: c.accentActivity,
              ),
              MetricItem(
                label: 'Sleep',
                value: '${snapshot.sleepHours.toStringAsFixed(1)}h',
                icon: Icons.bedtime,
                color: c.accentRecovery,
              ),
              MetricItem(
                label: 'Burned',
                value: snapshot.caloriesBurned.toString(),
                icon: Icons.local_fire_department,
                color: c.accentActivity,
              ),
              MetricItem(
                label: 'Consumed',
                value: snapshot.caloriesConsumed.toString(),
                icon: Icons.restaurant,
                color: c.accentRecovery,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
