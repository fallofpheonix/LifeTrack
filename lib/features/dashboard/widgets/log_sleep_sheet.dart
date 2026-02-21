import 'package:flutter/material.dart';
import 'package:lifetrack/data/models/sleep_entry.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';

typedef LogSleepCallback = void Function(SleepEntry entry);

/// Bottom sheet to log sleep (hours). Calls [onSave] with a new [SleepEntry] on save.
void showLogSleepSheet(BuildContext context, {required LogSleepCallback onSave}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _LogSleepSheet(onSave: onSave),
  );
}

class _LogSleepSheet extends StatefulWidget {
  const _LogSleepSheet({required this.onSave});

  final LogSleepCallback onSave;

  @override
  State<_LogSleepSheet> createState() => _LogSleepSheetState();
}

class _LogSleepSheetState extends State<_LogSleepSheet> {
  final TextEditingController _hoursController = TextEditingController(text: '8.0');

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  void _save() {
    final hours = double.tryParse(_hoursController.text);
    if (hours == null || hours <= 0 || hours > 24) return;
    final now = DateTime.now();
    final endTime = now.toUtc();
    final startTime = endTime.subtract(Duration(milliseconds: (hours * 3600 * 1000).round()));
    final entry = SleepEntry(
      id: now.microsecondsSinceEpoch.toString(),
      startTime: startTime,
      endTime: endTime,
    );
    widget.onSave(entry);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Log Sleep', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _hoursController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Hours Slept',
                hintText: '8.0',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _save,
              child: const Text('Save Sleep'),
            ),
          ],
        ),
      ),
    );
  }
}
