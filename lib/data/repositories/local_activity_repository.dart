import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lifetrack/core/data/repository/activity_repository.dart';
import 'package:lifetrack/data/models/activity_log.dart';
import 'package:lifetrack/core/services/background_service.dart';

class LocalActivityRepository implements ActivityRepository {
  static const String _key = 'activity_logs'; // Using the key from LifeTrackStore

  final SharedPreferences _prefs;

  LocalActivityRepository(this._prefs);

  @override
  Future<List<ActivityLog>> getActivities({DateTime? start, DateTime? end, bool includeDeleted = false}) async {
    final List<ActivityLog> all = await BackgroundService.decodeActivities(_prefs.getString(_key));
    return all.where((e) {
      if (!includeDeleted && e.deletedAt != null) return false;
      if (start != null && e.date.isBefore(start)) return false;
      if (end != null && e.date.isAfter(end)) return false;
      return true;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> saveActivity(ActivityLog log) async {
    final List<ActivityLog> all = await BackgroundService.decodeActivities(_prefs.getString(_key));
    final int index = all.indexWhere((e) => e.id == log.id);
    if (index != -1) {
      final old = all[index];
      all[index] = ActivityLog(
        id: log.id,
        type: log.type,
        name: log.name,
        durationMinutes: log.durationMinutes,
        caloriesBurned: log.caloriesBurned,
        date: log.date,
        source: log.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: log.deletedAt,
        entityVersion: old.entityVersion + 1,
      );
    } else {
      all.insert(0, log);
    }
    await _save(all);
  }

  @override
  Future<void> deleteActivity(String id) async {
    final List<ActivityLog> all = await BackgroundService.decodeActivities(_prefs.getString(_key));
    final int index = all.indexWhere((e) => e.id == id);
    if (index != -1) {
      final old = all[index];
      all[index] = ActivityLog(
        id: old.id,
        type: old.type,
        name: old.name,
        durationMinutes: old.durationMinutes,
        caloriesBurned: old.caloriesBurned,
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

  Future<void> _save(List<ActivityLog> list) async {
    final String jsonStr = jsonEncode(list.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, jsonStr);
  }
}
