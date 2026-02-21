import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/state/hydration_provider.dart';
import 'package:lifetrack/core/theme/app_colors_extension.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';

class HydrationCard extends ConsumerWidget {
  const HydrationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydration = ref.watch(hydrationProvider);
    final notifier = ref.read(hydrationProvider.notifier);
    final c = context.appColors;

    return BaseCard(
      child: Row(
        children: [
          Icon(Icons.water_drop, color: c.accentRecovery, size: 32),
          const SizedBox(width: AppSpacing.lg),
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
            padding: const EdgeInsets.all(AppSpacing.xs),
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton.filled(
            onPressed: notifier.addGlass,
            icon: const Icon(Icons.add),
            padding: const EdgeInsets.all(AppSpacing.xs),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
