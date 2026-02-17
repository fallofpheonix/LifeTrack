import 'package:flutter/material.dart';
import '../../data/models/activity_log.dart';
import '../../data/models/activity_type.dart';
import '../../core/utils/animated_fade_slide.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({
    super.key,
    required this.activities,
    required this.onLogActivity,
    required this.onDeleteActivity,
  });

  final List<ActivityLog> activities;
  final VoidCallback onLogActivity;
  final void Function(String id) onDeleteActivity;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text('Movement', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Text('Today\'s Activity', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            FilledButton.icon(
              onPressed: onLogActivity,
              icon: const Icon(Icons.add),
              label: const Text('Log Activity'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...activities.asMap().entries.map((MapEntry<int, ActivityLog> entry) {
          final int index = entry.key;
          final ActivityLog activity = entry.value;
          return AnimatedFadeSlide(
            delay: Duration(milliseconds: 120 + (index * 50)),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: <Widget>[
                    const CircleAvatar(child: Icon(Icons.fitness_center)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(activity.name, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 2),
                          Row(
                            children: <Widget>[
                               Icon(activity.type.icon, size: 14, color: Colors.grey),
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
                      onPressed: () => onDeleteActivity(activity.id),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
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
            value: _selectedType,
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

class SleepLogDialog extends StatefulWidget {
  const SleepLogDialog({super.key});

  @override
  State<SleepLogDialog> createState() => _SleepLogDialogState();
}

class _SleepLogDialogState extends State<SleepLogDialog> {
  DateTime _start = DateTime.now().subtract(const Duration(hours: 8));
  DateTime _end = DateTime.now();

  Future<void> _pickTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStart ? _start : _end),
    );
    if (picked != null) {
      setState(() {
        final DateTime base = isStart ? _start : _end;
        final DateTime newTime = DateTime(base.year, base.month, base.day, picked.hour, picked.minute);
        if (isStart) {
          _start = newTime;
        } else {
          _end = newTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Duration diff = _end.difference(_start);
    final String duration = '${diff.inHours}h ${diff.inMinutes % 60}m';

    return AlertDialog(
      title: const Text('Log Sleep'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('Bedtime'),
            trailing: Text(TimeOfDay.fromDateTime(_start).format(context)),
            onTap: () => _pickTime(true),
          ),
          ListTile(
            title: const Text('Wake up'),
            trailing: Text(TimeOfDay.fromDateTime(_end).format(context)),
            onTap: () => _pickTime(false),
          ),
          const SizedBox(height: 10),
          Text('Duration: $duration', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, <String, dynamic>{'start': _start, 'end': _end});
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
