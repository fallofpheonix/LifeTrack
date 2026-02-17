import 'package:flutter/material.dart';
import '../../data/models/reminder_item.dart';
import '../../core/utils/animated_fade_slide.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({
    super.key,
    required this.reminders,
    required this.onToggle,
  });

  final List<ReminderItem> reminders;
  final void Function(int index, bool enabled) onToggle;

  @override
  Widget build(BuildContext context) {
    final int activeCount = reminders.where((ReminderItem item) => item.enabled).length;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reminders.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.notifications_active)),
                title: const Text('Reminder Center'),
                subtitle: Text('$activeCount of ${reminders.length} reminders active'),
              ),
            ),
          );
        }
        final int reminderIndex = index - 1;
        final ReminderItem reminder = reminders[reminderIndex];
        return AnimatedFadeSlide(
          delay: Duration(milliseconds: 100 + (reminderIndex * 45)),
          child: Card(
            child: SwitchListTile(
              value: reminder.enabled,
              onChanged: (bool enabled) => onToggle(reminderIndex, enabled),
              title: Text(reminder.title),
              subtitle: Text(reminder.timeLabel),
            ),
          ),
        );
      },
    );
  }
}
