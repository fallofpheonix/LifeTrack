import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/domain/education/providers.dart';
import 'package:lifetrack/domain/education/models/condition.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/core/ui/empty_state.dart';

class LearnTab extends ConsumerWidget {
  const LearnTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conditionsAsync = ref.watch(conditionProvider);

    return conditionsAsync.when(
      data: (conditions) {
        if (conditions.isEmpty) {
            return const EmptyState(title: "No conditions found", icon: Icons.library_books);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: conditions.length,
          itemBuilder: (context, index) {
            return _ConditionTile(condition: conditions[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Center(child: Text('Error loading conditions: $e')),
    );
  }
}

class _ConditionTile extends StatelessWidget {
  final Condition condition;

  const _ConditionTile({required this.condition});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        title: Text(
          condition.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(condition.category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        leading: const Icon(Icons.local_hospital_outlined),
        childrenPadding: const EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(condition.summary, style: const TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 12),
          _InfoRow(label: 'Symptoms', items: condition.symptoms),
          const SizedBox(height: 8),
          _InfoRow(label: 'Prevention', items: condition.prevention),
          const SizedBox(height: 8),
          _InfoRow(label: 'Management', items: condition.management),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final List<String> items;
  
  const _InfoRow({required this.label, required this.items});
  
  @override
  Widget build(BuildContext context) {
      if (items.isEmpty) return const SizedBox.shrink();
      
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(label, style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold, 
                  color: Theme.of(context).colorScheme.primary
              )),
              const SizedBox(height: 4),
              ...items.map((i) => Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 2),
                  child: Text("• $i", style: const TextStyle(fontSize: 13)),
              )),
          ],
      );
  }
}
