import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/state/records_provider.dart';
import 'package:lifetrack/design_system/motion/app_motion.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';
import 'package:lifetrack/features/medical/ui/widgets/fact_banner.dart';
import 'package:lifetrack/features/medical/ui/widgets/record_card.dart';
import 'package:lifetrack/presentation/medical/providers/medical_providers.dart';

class RecordsTab extends ConsumerWidget {
  const RecordsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mockAsync = ref.watch(personalLogProvider);
    final records = ref.watch(recordsProvider);
    final fact = ref.watch(didYouKnowProvider).asData?.value;

    return mockAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace stackTrace) => const SizedBox.shrink(),
      data: (mockRecords) => ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: <Widget>[
          ...mockRecords
              .map((r) => AnimatedOpacity(opacity: 1, duration: AppMotion.fadeIn, child: RecordCard(record: r)))
              ,
          if (fact != null) FactBanner(text: fact),
          if (records.isNotEmpty)
            Text('Clinical Records', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
