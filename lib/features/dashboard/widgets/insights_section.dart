import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/state/insight_provider.dart';
import 'package:lifetrack/data/models/intelligence/insight.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/core/ui/section_header.dart';
import 'package:lifetrack/core/ui/empty_state.dart';

class InsightsSection extends ConsumerWidget {
  const InsightsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(insightProvider);

    if (insights.isEmpty) {
      // Optional: Don't show anything if empty, or show a friendly empty state
      // For now, let's just return a placeholder or empty SizedBox if distinct area
      // User requested "SectionHeader" so let's include it.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const SectionHeader(title: 'Insights'),
           const BaseCard(
             child: EmptyState(
               title: 'No insights yet',
               icon: Icons.lightbulb_outline,
               subtitle: 'Keep logging to unlock personalized feedback.',
             ),
           ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Insights'),
        ...insights.map((insight) => _InsightCard(insight: insight)),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final Insight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    // Determine color based on type/severity if available
    // Assuming Insight has a type property
    final Color color = insight.type == InsightType.alert ? Colors.red : Colors.blue;
    final IconData icon = insight.type == InsightType.alert ? Icons.warning : Icons.info;

    return BaseCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(insight.message),
                 if (insight.actionLabel != null) ...[
                   const SizedBox(height: 8),
                   GestureDetector(
                     onTap: () {
                       // TODO: Handle action
                     },
                     child: Text(
                       insight.actionLabel!,
                       style: TextStyle(
                         color: Theme.of(context).colorScheme.primary,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                 ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
