import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lifetrack/core/data/repository/sleep_repository.dart';
import 'package:lifetrack/data/models/sleep_entry.dart';
import 'package:lifetrack/core/services/background_service.dart';

class LocalSleepRepository implements SleepRepository {
  static const String _key = 'sleep_logs';

  final SharedPreferences _prefs;

  LocalSleepRepository(this._prefs);

  @override
  Future<List<SleepEntry>> getSleepLogs({DateTime? start, DateTime? end, bool includeDeleted = false}) async {
    final List<SleepEntry> all = await BackgroundService.decodeSleep(_prefs.getString(_key));
    return all.where((e) {
      if (!includeDeleted && e.deletedAt != null) return false;
      if (start != null && e.startTime.isBefore(start)) return false;
      if (end != null && e.startTime.isAfter(end)) return false;
      return true;
    }).toList()..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  @override
  Future<void> saveSleepLog(SleepEntry entry) async {
    final List<SleepEntry> all = await BackgroundService.decodeSleep(_prefs.getString(_key));
    final int index = all.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      final old = all[index];
      all[index] = SleepEntry(
        id: entry.id,
        startTime: entry.startTime,
        endTime: entry.endTime,
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
  Future<void> deleteSleepLog(String id) async {
    final List<SleepEntry> all = await BackgroundService.decodeSleep(_prefs.getString(_key));
    final int index = all.indexWhere((e) => e.id == id);
    if (index != -1) {
      final old = all[index];
      all[index] = SleepEntry(
        id: old.id,
        startTime: old.startTime,
        endTime: old.endTime,
        source: old.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: DateTime.now().toUtc(),
        entityVersion: old.entityVersion + 1,
      );
      await _save(all);
    }
  }

  Future<void> _save(List<SleepEntry> list) async {
    final String jsonStr = jsonEncode(list.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, jsonStr);
  }
}
