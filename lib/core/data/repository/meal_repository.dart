import 'package:lifetrack/data/models/meal_entry.dart';

abstract class MealRepository {
  Future<List<MealEntry>> getMeals({DateTime? start, DateTime? end, bool includeDeleted = false});
  Future<void> saveMeal(MealEntry entry);
  Future<void> deleteMeal(String id);
}
