import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/design_system/motion/app_motion.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';
import 'package:lifetrack/features/medical/ui/widgets/fact_banner.dart';
import 'package:lifetrack/features/medical/ui/widgets/pioneer_card.dart';
import 'package:lifetrack/features/medical/ui/widgets/research_card.dart';
import 'package:lifetrack/presentation/medical/providers/medical_providers.dart';

class InsightsTab extends ConsumerWidget {
  const InsightsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pioneersAsync = ref.watch(pioneersProvider);
    final insightsAsync = ref.watch(insightsFeedProvider);
    final fact = ref.watch(didYouKnowProvider).asData?.value;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        Text('Medical Pioneers', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.sm),
        pioneersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => const SizedBox.shrink(),
          data: (pioneers) => Column(
            children: pioneers
                .map((p) => AnimatedOpacity(opacity: 1, duration: AppMotion.fadeIn, child: PioneerCard(pioneer: p)))
                .toList(growable: false),
          ),
        ),
        if (fact != null) FactBanner(text: fact),
        Text('Latest Evidence', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.sm),
        insightsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => const SizedBox.shrink(),
          data: (insights) => Column(
            children: insights
                .map((i) => AnimatedOpacity(opacity: 1, duration: AppMotion.fadeIn, child: ResearchCard(item: i)))
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
