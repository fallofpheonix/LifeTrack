import 'package:flutter/material.dart';
import 'package:lifetrack/data/models/activity_log.dart';
import 'package:lifetrack/data/models/activity_type.dart';

/// Result map: 'type' (ActivityType), 'duration' (int), 'calories' (int).
/// Returns null when cancelled.
Future<Map<String, dynamic>?> showAddActivityDialog(BuildContext context) async {
  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => const AddActivityDialog(),
  );
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
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

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
                setState(() => _selectedType = value);
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
