import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/state/store_provider.dart';
import 'package:lifetrack/core/theme/app_colors_extension.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/core/ui/empty_state.dart';
import 'package:lifetrack/data/models/activity_log.dart';
import 'package:lifetrack/data/models/activity_type.dart';
import 'package:lifetrack/core/utils/animated_fade_slide.dart';
import 'package:lifetrack/core/ui/app_page_layout.dart';
import 'package:lifetrack/features/activity/widgets/add_activity_dialog.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';

class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(lifeTrackStoreProvider);
    final activities = store.activities;

    return AppPageLayout(
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Movement', style: Theme.of(context).textTheme.titleLarge),
            FilledButton.icon(
              onPressed: () async {
                  final result = await showAddActivityDialog(context);
                  if (result != null) {
                     final ActivityLog log = ActivityLog(
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
              icon: const Icon(Icons.add),
              label: const Text('Log Activity'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (activities.isEmpty)
           const Padding(
             padding: EdgeInsets.only(top: 40),
             child: BaseCard(child: EmptyState(title: "No activity today", icon: Icons.directions_run)),
           )
        else
          ...activities.asMap().entries.map((MapEntry<int, ActivityLog> entry) {
            final int index = entry.key;
            final ActivityLog activity = entry.value;
            final c = context.appColors;
            IconData icon = Icons.fitness_center;
            try {
               final type = activity.activityType;
               icon = type.icon;
            } catch (e) {
               // Fallback
            }

            return AnimatedFadeSlide(
              delay: Duration(milliseconds: 120 + (index * 50)),
              child: BaseCard(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: c.accentActivity.withValues(alpha: 0.15),
                      child: Icon(icon, color: c.accentActivity),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(activity.name, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 2),
                          Row(
                            children: <Widget>[
                               Icon(icon, size: 14, color: c.textSecondary),
                               const SizedBox(width: AppSpacing.xs),
                               Text('${activity.durationMinutes} min'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      label: Text(
                        '-${activity.caloriesBurned} kcal',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, size: 20, color: c.textSecondary),
                      onPressed: () => store.deleteActivity(activity.id),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
      ),
    );
  }
}

