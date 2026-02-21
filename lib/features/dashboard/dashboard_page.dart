import 'package:flutter/material.dart';
import 'package:lifetrack/features/dashboard/widgets/today_summary_section.dart';
import 'package:lifetrack/features/dashboard/widgets/insights_section.dart';
import 'package:lifetrack/features/dashboard/widgets/hydration_card.dart';
import 'package:lifetrack/features/dashboard/widgets/quick_actions_section.dart';
import 'package:lifetrack/features/dashboard/widgets/quote_banner.dart';
import 'package:lifetrack/domain/education/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/ui/app_page_layout.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      child: ListView(
        children: [
          const TodaySummarySection(),
          const SizedBox(height: 16),
          const InsightsSection(),
          const SizedBox(height: 16),
          const HydrationCard(),
          const SizedBox(height: 16),
          const _QuoteSection(),
          const SizedBox(height: 16),
          const QuickActionsSection(),
        ],
      ),
    );
  }
}

class _QuoteSection extends ConsumerWidget {
  const _QuoteSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, just grab a quote related to 'hydration' or 'activity' as default context
    final quoteAsync = ref.watch(quoteProvider('activity'));

    return quoteAsync.when(
      data: (quote) => quote != null ? QuoteBanner(quote: quote) : const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
      error: (Object error, StackTrace stackTrace) => const SizedBox.shrink(),
    );
  }
}
