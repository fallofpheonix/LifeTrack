import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lifetrack/core/data/repository/meal_repository.dart';
import 'package:lifetrack/data/models/meal_entry.dart';
import 'package:lifetrack/core/services/background_service.dart';

class LocalMealRepository implements MealRepository {
  static const String _key = 'meal_logs';

  final SharedPreferences _prefs;

  LocalMealRepository(this._prefs);

  @override
  Future<List<MealEntry>> getMeals({DateTime? start, DateTime? end, bool includeDeleted = false}) async {
    final List<MealEntry> all = await BackgroundService.decodeMeals(_prefs.getString(_key));
    return all.where((e) {
      if (!includeDeleted && e.deletedAt != null) return false;
      if (start != null && e.date.isBefore(start)) return false;
      if (end != null && e.date.isAfter(end)) return false;
      return true;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> saveMeal(MealEntry entry) async {
    final List<MealEntry> all = await BackgroundService.decodeMeals(_prefs.getString(_key));
    final int index = all.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      final old = all[index];
      all[index] = MealEntry(
        id: entry.id,
        mealType: entry.mealType,
        title: entry.title,
        calories: entry.calories,
        date: entry.date,
        source: entry.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: entry.deletedAt,
        entityVersion: old.entityVersion + 1,
      );
    } else {
      all.insert(0, entry);
    }
    await _save(all);
  }

  @override
  Future<void> deleteMeal(String id) async {
    final List<MealEntry> all = await BackgroundService.decodeMeals(_prefs.getString(_key));
    final int index = all.indexWhere((e) => e.id == id);
    if (index != -1) {
      final old = all[index];
      all[index] = MealEntry(
        id: old.id,
        mealType: old.mealType,
        title: old.title,
        calories: old.calories,
        date: old.date,
        source: old.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: DateTime.now().toUtc(),
        entityVersion: old.entityVersion + 1,
      );
      await _save(all);
    }
  }

  Future<void> _save(List<MealEntry> list) async {
    final String jsonStr = jsonEncode(list.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, jsonStr);
  }
}
