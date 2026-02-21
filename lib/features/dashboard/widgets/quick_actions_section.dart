import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/state/store_provider.dart';
import 'package:lifetrack/data/models/activity_log.dart';
import 'package:lifetrack/data/models/activity_type.dart';
import 'package:lifetrack/data/models/sleep_entry.dart';
import 'package:lifetrack/design_system/components/action_card.dart';
import 'package:lifetrack/features/activity/widgets/add_activity_dialog.dart';
import 'package:lifetrack/features/dashboard/widgets/log_sleep_sheet.dart';

class QuickActionsSection extends ConsumerWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.read(lifeTrackStoreProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: ActionCard(
            icon: Icons.directions_run,
            label: 'Log Run',
            iconColor: colorScheme.primary,
            onTap: () async {
              final result = await showAddActivityDialog(context);
              if (result != null && context.mounted) {
                final log = ActivityLog(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: result['type'] as ActivityType,
                  name: (result['type'] as ActivityType).displayName,
                  durationMinutes: result['duration'] as int,
                  caloriesBurned: result['calories'] as int,
                  date: DateTime.now(),
                );
                store.addActivity(log);
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ActionCard(
            icon: Icons.bedtime,
            label: 'Add Sleep',
            iconColor: colorScheme.secondary,
            onTap: () {
              showLogSleepSheet(context, onSave: (SleepEntry entry) {
                store.addSleepLog(entry);
              });
            },
          ),
        ),
      ],
    );
  }
}
