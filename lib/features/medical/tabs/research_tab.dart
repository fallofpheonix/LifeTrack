import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/domain/education/providers.dart';
import 'package:lifetrack/domain/education/models/scientist.dart';
import 'package:lifetrack/domain/education/models/evidence.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/core/ui/section_header.dart';

class ResearchTab extends ConsumerWidget {
  const ResearchTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evidenceAsync = ref.watch(allEvidenceProvider);
    final scientistsAsync = ref.watch(scientistProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Latest Evidence'),
        evidenceAsync.when(
          data: (List<Evidence> evidenceList) => Column(
            children: evidenceList.map((e) => _EvidenceCard(evidence: e)).toList(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, __) => Text('Error loading evidence: $e'),
        ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'Pioneers'),
        scientistsAsync.when(
          data: (List<Scientist> scientists) => Column(
            children: scientists.map((s) => _ScientistCard(scientist: s)).toList(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, __) => Text('Error loading scientists: $e'),
        ),
      ],
    );
  }
}

class _EvidenceCard extends StatelessWidget {
  final Evidence evidence;

  const _EvidenceCard({required this.evidence});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.science, color: Theme.of(context).colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '${evidence.year} • ${evidence.sourceType.toUpperCase()}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
              ),
              const Spacer(),
              Text(
                '${(evidence.confidence * 100).toInt()}% Conf.',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            evidence.statement,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: evidence.relatedMetrics.map((m) => Chip(
              label: Text(m, style: const TextStyle(fontSize: 10)),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _ScientistCard extends StatelessWidget {
  final Scientist scientist;

  const _ScientistCard({required this.scientist});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
             radius: 24,
             backgroundColor: Theme.of(context).colorScheme.primaryContainer,
             child: Text(scientist.name[0], style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scientist.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(scientist.domain, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 4),
                Text(scientist.fact, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
