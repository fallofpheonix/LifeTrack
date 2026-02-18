import 'package:flutter/material.dart';
import 'package:lifetrack/domain/education/models/quote.dart';
import 'package:lifetrack/core/ui/base_card.dart';

class QuoteBanner extends StatelessWidget {
  final HealthQuote quote;

  const QuoteBanner({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.format_quote, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'DID YOU KNOW?',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            quote.text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
