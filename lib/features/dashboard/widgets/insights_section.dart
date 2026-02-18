import 'package:flutter/material.dart';
import '../../../data/models/intelligence/insight.dart';

class InsightsSection extends StatelessWidget {
  const InsightsSection({super.key, required this.insights});

  final List<Insight> insights;

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Health Insights',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: insights.length,
            itemBuilder: (context, index) {
              return _InsightCard(insight: insights[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight});

  final Insight insight;

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = insight.type == InsightType.success;
    final Color color = isSuccess ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0);
    final Color iconColor = isSuccess ? Colors.green : Colors.orange;
    final IconData icon = isSuccess ? Icons.check_circle_outline : Icons.info_outline;

    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insight.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              insight.message,
              style: const TextStyle(fontSize: 12, height: 1.4),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (insight.actionLabel != null)
             Text(
               insight.actionLabel!.toUpperCase(),
               style: TextStyle(
                 color: iconColor, 
                 fontSize: 10, 
                 fontWeight: FontWeight.bold
               ),
             ),
        ],
      ),
    );
  }
}
