import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/state/store_provider.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/core/ui/empty_state.dart';
import 'package:lifetrack/data/models/activity_log.dart';
import 'package:lifetrack/data/models/activity_type.dart';
import 'package:lifetrack/core/utils/animated_fade_slide.dart';
import 'package:lifetrack/core/ui/app_page_layout.dart';

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
                  final result = await showDialog(
                    context: context,
                    builder: (context) => const AddActivityDialog(),
                  );
                  if (result != null && result is Map) {
                     final ActivityLog log = ActivityLog(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        type: result['type'] as ActivityType, 
                        name: (result['type'] as ActivityType).displayName,
                        durationMinutes: result['duration'],
                        caloriesBurned: result['calories'],
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
        const SizedBox(height: 12),
        if (activities.isEmpty)
           const Padding(
             padding: EdgeInsets.only(top: 40),
             child: BaseCard(child: EmptyState(title: "No activity today", icon: Icons.directions_run)),
           )
        else
          ...activities.asMap().entries.map((MapEntry<int, ActivityLog> entry) {
            final int index = entry.key;
            final ActivityLog activity = entry.value;
            // Helper to get icon from type name
            IconData icon = Icons.fitness_center;
            try {
               // Use the type directly from the model
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
                      backgroundColor: Colors.orange.withValues(alpha: 0.1),
                      child: Icon(icon, color: Colors.orange),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(activity.name, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 2),
                          Row(
                            children: <Widget>[
                               Icon(icon, size: 14, color: Colors.grey),
                               const SizedBox(width: 4),
                               Text('${activity.durationMinutes} min'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEE0),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '-${activity.caloriesBurned} kcal',
                        style: const TextStyle(
                          color: Color(0xFFB45A11),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
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

class AddActivityDialog extends StatefulWidget {
  const AddActivityDialog({super.key});

  @override
  State<AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  ActivityType _selectedType = ActivityType.run;
  final TextEditingController _durationController = TextEditingController(text: '30');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Activity'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownButtonFormField<ActivityType>(
            initialValue: _selectedType,
            decoration: const InputDecoration(labelText: 'Activity Type'),
            items: ActivityType.values.map((ActivityType type) {
              return DropdownMenuItem<ActivityType>(
                value: type,
                child: Row(
                  children: <Widget>[
                    Icon(type.icon, size: 16),
                    const SizedBox(width: 8),
                    Text(type.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (ActivityType? value) {
              if (value != null) {
                setState(() {
                  _selectedType = value;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Duration (minutes)'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final int duration = int.tryParse(_durationController.text) ?? 0;
            if (duration > 0) {
              final int calories = duration * _selectedType.caloriesPerMinute;
              Navigator.pop(context, <String, dynamic>{
                'type': _selectedType,
                'duration': duration,
                'calories': calories,
              });
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
