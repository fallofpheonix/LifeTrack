import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/domain/education/models/disease.dart';
import 'package:lifetrack/features/medical/widgets/did_you_know_banner.dart';
import 'package:lifetrack/presentation/medical/providers/medical_providers.dart';

class LearnTab extends ConsumerWidget {
  const LearnTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diseasesAsync = ref.watch(rotatingDiseaseProvider);
    final factAsync = ref.watch(didYouKnowProvider);
    final String? fact = factAsync.asData?.value;

    return diseasesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace stackTrace) => Center(
        child: Text(
          'Unable to load health library.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      data: (List<Disease> diseases) {
        final List<Widget> children = <Widget>[];

        for (int i = 0; i < diseases.length; i++) {
          children.add(
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 260 + (i * 75)),
              curve: Curves.easeOutCubic,
              builder: (BuildContext context, double value, Widget? child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 10),
                    child: child,
                  ),
                );
              },
              child: _DiseaseCard(disease: diseases[i]),
            ),
          );
          if ((i == 1 || i == 3) && fact != null) {
            children.add(DidYouKnowBanner(text: fact));
          }
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          child: ListView(
            key: const ValueKey<String>('health-library-list'),
            padding: const EdgeInsets.all(16),
            children: children,
          ),
        );
      },
    );
  }
}

class _DiseaseCard extends StatelessWidget {
  const _DiseaseCard({required this.disease});

  final Disease disease;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.local_hospital_outlined, color: scheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  disease.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(disease.desc, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          Text('Prevention Tip', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(disease.prevention, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Wrap(
            children: <Widget>[
              Chip(
                visualDensity: VisualDensity.compact,
                label: Text('Risk Group: ${disease.risk}', style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
