import 'package:flutter/material.dart';
import 'package:lifetrack/core/ui/base_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BaseCard(
            onTap: () {
              // Show Activity Sheet
               showModalBottomSheet(
                 context: context,
                 isScrollControlled: true,
                 builder: (context) => DraggableScrollableSheet(
                   initialChildSize: 0.6,
                   minChildSize: 0.4,
                   maxChildSize: 0.9,
                   expand: false,
                   builder: (context, scrollController) => ListView(
                     controller: scrollController,
                     padding: const EdgeInsets.all(24),
                     children: [
                       Text('Log Activity', style: Theme.of(context).textTheme.headlineSmall),
                       const SizedBox(height: 16),
                       const TextField(decoration: InputDecoration(labelText: 'Activity Type', hintText: 'e.g., Running')),
                       const SizedBox(height: 16),
                       const TextField(decoration: InputDecoration(labelText: 'Duration (min)', hintText: '30')),
                       const SizedBox(height: 24),
                       FilledButton(
                         onPressed: () => Navigator.pop(context),
                         child: const Text('Save Activity'),
                       ),
                     ],
                   ),
                 ),
               );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_run, size: 32, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 8),
                Text('Log Run', style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: BaseCard(
            onTap: () {
              // Show Sleep Sheet
               showModalBottomSheet(
                 context: context,
                 builder: (context) => Container(
                   padding: const EdgeInsets.all(24),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     children: [
                       Text('Log Sleep', style: Theme.of(context).textTheme.headlineSmall),
                       const SizedBox(height: 16),
                       const TextField(decoration: InputDecoration(labelText: 'Hours Slept', hintText: '8.0')),
                       const SizedBox(height: 24),
                       FilledButton(
                         onPressed: () => Navigator.pop(context),
                         child: const Text('Save Sleep'),
                       ),
                     ],
                   ),
                 ),
               );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bedtime, size: 32, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(height: 8),
                Text('Add Sleep', style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
