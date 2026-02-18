import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/state/health_snapshot_provider.dart';
import 'package:lifetrack/core/ui/base_card.dart';

class TodaySummarySection extends ConsumerWidget {
  const TodaySummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(healthSnapshotProvider);

    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MetricItem(
                label: 'Steps',
                value: snapshot.steps.toString(),
                icon: Icons.directions_walk,
                color: Colors.orange,
              ),
              _MetricItem(
                label: 'Sleep',
                value: '${snapshot.sleepHours}h',
                icon: Icons.bedtime,
                color: Colors.purple,
              ),
              _MetricItem(
                label: 'Calories',
                value: snapshot.caloriesBurned.toString(),
                icon: Icons.local_fire_department,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
