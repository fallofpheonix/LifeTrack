import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/state/records_provider.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/core/ui/empty_state.dart';
import 'package:lifetrack/data/models/health_record_entry.dart';

class MyRecordsTab extends ConsumerWidget {
  const MyRecordsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(recordsProvider);

    if (records.isEmpty) {
      return EmptyState(
        title: 'No health records yet',
        subtitle: 'Add a record to track your medical history.',
        icon: Icons.assignment_outlined,
        actionLabel: 'Add Record',
        onAction: () {
            // TODO: Open Add Record Sheet
             _showAddRecordSheet(context);
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return _RecordCard(record: record);
      },
    );
  }

  void _showAddRecordSheet(BuildContext context) {
      // Placeholder for Add Record Sheet
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            padding: const EdgeInsets.all(24),
            child: const Text("Add Record Form Placeholder"),
        )
      );
  }
}

class _RecordCard extends StatelessWidget {
  final HealthRecordEntry record;

  const _RecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_note, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                record.dateLabel,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const Spacer(),
              // Delete action could go here
            ],
          ),
          const SizedBox(height: 8),
          Text(
            record.condition,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (record.vitals.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('Vitals: ${record.vitals}', style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (record.note.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(record.note, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
