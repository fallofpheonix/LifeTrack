import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/domain/education/models/pioneer.dart';
import 'package:lifetrack/domain/education/models/research_item.dart';
import 'package:lifetrack/features/medical/widgets/did_you_know_banner.dart';
import 'package:lifetrack/presentation/medical/providers/medical_providers.dart';

class ResearchTab extends ConsumerWidget {
  const ResearchTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pioneersAsync = ref.watch(pioneersProvider);
    final feedAsync = ref.watch(insightsFeedProvider);
    final factAsync = ref.watch(didYouKnowProvider);
    final String? fact = factAsync.asData?.value;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text('Medical Pioneers', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        pioneersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => const SizedBox.shrink(),
          data: (List<Pioneer> pioneers) => Column(
              children: List<Widget>.generate(pioneers.length, (int i) {
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 260 + (i * 70)),
                  curve: Curves.easeOutCubic,
                  builder: (BuildContext context, double value, Widget? child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(offset: Offset(0, (1 - value) * 12), child: child),
                    );
                  },
                  child: _PioneerCard(profile: pioneers[i]),
                );
              }),
            ),
        ),
        if (fact != null) DidYouKnowBanner(text: fact),
        Text('Latest Evidence', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        feedAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => const SizedBox.shrink(),
          data: (List<ResearchItem> updates) => Column(
              children: List<Widget>.generate(updates.length, (int i) {
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 260 + (i * 60)),
                  curve: Curves.easeOutCubic,
                  builder: (BuildContext context, double value, Widget? child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(offset: Offset(0, (1 - value) * 10), child: child),
                    );
                  },
                  child: _EvidenceFeedCard(update: updates[i]),
                );
              }),
            ),
        ),
      ],
    );
  }
}

class _PioneerCard extends StatelessWidget {
  const _PioneerCard({required this.profile});

  final Pioneer profile;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return BaseCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 26,
            backgroundColor: scheme.primaryContainer,
            backgroundImage: AssetImage(profile.imageAsset),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(profile.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(profile.contribution, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                Text('Why it matters: ${profile.relevance}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EvidenceFeedCard extends StatelessWidget {
  const _EvidenceFeedCard({required this.update});

  final ResearchItem update;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.science_outlined, color: scheme.primary, size: 18),
              const SizedBox(width: 8),
              Chip(
                visualDensity: VisualDensity.compact,
                label: Text(update.source, style: Theme.of(context).textTheme.labelSmall),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(update.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(update.impact, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
