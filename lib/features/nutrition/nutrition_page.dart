import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/state/store_provider.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/core/ui/empty_state.dart';
import 'package:lifetrack/data/models/meal_entry.dart';
import 'package:lifetrack/core/utils/animated_fade_slide.dart';
import 'package:lifetrack/core/ui/app_page_layout.dart';

class NutritionPage extends ConsumerWidget {
  const NutritionPage({super.key});

  IconData _mealIcon(String mealType) {
    // ... existing ...
    final String normalized = mealType.toLowerCase();
    if (normalized.contains('breakfast')) {
      return Icons.wb_sunny_outlined;
    }
    if (normalized.contains('lunch')) {
      return Icons.lunch_dining_outlined;
    }
    if (normalized.contains('dinner')) {
      return Icons.nightlight_round;
    }
    return Icons.local_cafe_outlined;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(lifeTrackStoreProvider);
    final meals = store.meals;
    final int totalCalories = meals.fold<int>(0, (int sum, MealEntry item) => sum + item.calories);

    return AppPageLayout(
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Nutrition', style: Theme.of(context).textTheme.titleLarge),
            FilledButton.icon(
              onPressed: () async {
                final dynamic result = await showDialog(
                  context: context,
                  builder: (BuildContext context) => const MealCalculatorDialog(),
                );
                if (result != null && result is Map<String, dynamic>) {
                   final MealEntry meal = MealEntry(
                     id: DateTime.now().microsecondsSinceEpoch.toString(),
                     mealType: 'Snack',
                     title: result['title'] as String,
                     calories: result['calories'] as int,
                     date: DateTime.now(),
                   );
                   store.addMeal(meal);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Meal'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        BaseCard(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.restaurant)),
            title: const Text('Daily Nutrition Overview'),
            subtitle: Text('Consumed calories: $totalCalories kcal'),
          ),
        ),
        const SizedBox(height: 12),
        if (meals.isEmpty)
           const Padding(
             padding: EdgeInsets.only(top: 40),
             child: BaseCard(child: EmptyState(title: "No meals logged", icon: Icons.restaurant_menu)),
           )
        else
          ...meals.asMap().entries.map((MapEntry<int, MealEntry> entry) {
            final int index = entry.key;
            final MealEntry meal = entry.value;
            return AnimatedFadeSlide(
              delay: Duration(milliseconds: 100 + (index * 45)),
              child: BaseCard(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFDFF2EC),
                    child: Icon(_mealIcon(meal.mealType), color: const Color(0xFF1D8A6F)),
                  ),
                  title: Text('${meal.mealType}: ${meal.title}'),
                  subtitle: Text('${meal.calories} kcal'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => store.deleteMeal(meal.id),
                  ),
                ),
              ),
            );
          }),
      ],
      ),
    );
  }
}

class MealCalculatorDialog extends StatefulWidget {
  const MealCalculatorDialog({super.key});

  @override
  State<MealCalculatorDialog> createState() => _MealCalculatorDialogState();
}

class _MealCalculatorDialogState extends State<MealCalculatorDialog> {
  final List<Map<String, dynamic>> _items = <Map<String, dynamic>>[];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _calsController = TextEditingController();

  void _addItem() {
    final String name = _itemController.text.trim();
    final int? cals = int.tryParse(_calsController.text);
    if (name.isNotEmpty && cals != null) {
      setState(() {
        _items.add(<String, dynamic>{'name': name, 'calories': cals});
      });
      _itemController.clear();
      _calsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int total = _items.fold<int>(0, (int p, Map<String, dynamic> c) => p + (c['calories'] as int));

    return AlertDialog(
      title: const Text('Meal Calculator'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(labelText: 'Item (e.g. apple)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _calsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Kcal'),
                  ),
                ),
                IconButton(onPressed: _addItem, icon: const Icon(Icons.add_circle)),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> item = _items[index];
                  return ListTile(
                    dense: true,
                    title: Text(item['name'] as String),
                    trailing: Text('${item['calories']} kcal'),
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('$total kcal', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D8A6F))),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: _items.isEmpty
              ? null
              : () {
                  Navigator.pop(context, <String, dynamic>{'title': 'Calculated Meal', 'calories': total});
                },
          child: const Text('Add Meal'),
        ),
      ],
    );
  }
}
