import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/state/records_provider.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/data/models/health_record_entry.dart';
import 'package:lifetrack/domain/education/models/mock_health_record.dart';
import 'package:lifetrack/features/medical/widgets/did_you_know_banner.dart';
import 'package:lifetrack/presentation/medical/providers/medical_providers.dart';

class MyRecordsTab extends ConsumerWidget {
  const MyRecordsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<HealthRecordEntry> records = ref.watch(recordsProvider);
    final recordsAsync = ref.watch(personalLogProvider);
    final factAsync = ref.watch(didYouKnowProvider);
    final String? fact = factAsync.asData?.value;

    return recordsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace stackTrace) => const SizedBox.shrink(),
      data: (List<MockHealthRecord> demo) => ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          ...List<Widget>.generate(demo.length, (int index) {
            final MockHealthRecord item = demo[index];
            return Column(
              children: <Widget>[
                _MetricCard(metric: item, index: index),
                if ((index == 1 || index == 4) && fact != null)
                  DidYouKnowBanner(text: fact),
              ],
            );
          }),
          if (records.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              'Clinical Records',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...records.map((HealthRecordEntry record) => _RecordCard(record: record)),
          ],
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric, required this.index});

  final MockHealthRecord metric;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color trendColor = metric.isUp ? scheme.tertiary : scheme.error;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + (index * 70)),
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10),
            child: child,
          ),
        );
      },
      child: BaseCard(
        child: Row(
          children: <Widget>[
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.monitor_heart_outlined, color: scheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(metric.metric, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(_formatDate(metric.date), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(metric.value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Icon(metric.isUp ? Icons.arrow_upward : Icons.arrow_downward, size: 14, color: trendColor),
                    const SizedBox(width: 2),
                    Text('Last updated ${metric.time}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime target = DateTime(date.year, date.month, date.day);
    if (target == today) {
      return 'Today';
    }
    if (target == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final HealthRecordEntry record;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.event_note, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(record.dateLabel, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 8),
          Text(record.condition, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          if (record.vitals.isNotEmpty) ...<Widget>[
            const SizedBox(height: 4),
            Text('Vitals: ${record.vitals}', style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (record.note.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(record.note, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
