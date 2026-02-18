import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/state/hydration_provider.dart';
import 'package:lifetrack/core/ui/base_card.dart';

class HydrationCard extends ConsumerWidget {
  const HydrationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydration = ref.watch(hydrationProvider);
    final notifier = ref.read(hydrationProvider.notifier);

    return BaseCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.water_drop, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hydration',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '${hydration.current}/${hydration.goal} glasses',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: notifier.removeGlass,
            icon: const Icon(Icons.remove),
            padding: const EdgeInsets.all(4), 
             constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: notifier.addGlass,
            icon: const Icon(Icons.add),
             padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
