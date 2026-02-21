import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/design_system/motion/app_motion.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';
import 'package:lifetrack/features/medical/ui/widgets/disease_card.dart';
import 'package:lifetrack/features/medical/ui/widgets/fact_banner.dart';
import 'package:lifetrack/presentation/medical/providers/medical_providers.dart';

class LibraryTab extends ConsumerWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diseasesAsync = ref.watch(rotatingDiseaseProvider);
    final fact = ref.watch(didYouKnowProvider).asData?.value;

    return diseasesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace stackTrace) => const SizedBox.shrink(),
      data: (diseases) => ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: diseases.length + ((fact != null && diseases.length > 2) ? 1 : 0),
        itemBuilder: (BuildContext context, int i) {
          if (fact != null && i == 2) {
            return AnimatedOpacity(opacity: 1, duration: AppMotion.fadeIn, child: FactBanner(text: fact));
          }
          final diseaseIndex = (fact != null && i > 2) ? i - 1 : i;
          return AnimatedOpacity(
            opacity: 1,
            duration: AppMotion.fadeIn,
            child: DiseaseCard(disease: diseases[diseaseIndex]),
          );
        },
      ),
    );
  }
}
