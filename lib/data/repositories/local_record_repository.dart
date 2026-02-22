import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lifetrack/core/data/repository/record_repository.dart';
import 'package:lifetrack/data/models/health_record_entry.dart';
import 'package:lifetrack/core/services/background_service.dart';

class LocalRecordRepository implements RecordRepository {
  static const String _key = 'health_records';

  final SharedPreferences _prefs;

  LocalRecordRepository(this._prefs);

  @override
  Future<List<HealthRecordEntry>> getRecords({DateTime? start, DateTime? end, bool includeDeleted = false}) async {
    final List<HealthRecordEntry> all = await BackgroundService.decodeRecords(_prefs.getString(_key));
    return all.where((e) {
      if (!includeDeleted && e.deletedAt != null) return false;
      if (start != null && e.date.isBefore(start)) return false;
      if (end != null && e.date.isAfter(end)) return false;
      return true;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> saveRecord(HealthRecordEntry record) async {
    final List<HealthRecordEntry> all = await BackgroundService.decodeRecords(_prefs.getString(_key));
    final int index = all.indexWhere((e) => e.id == record.id);
    if (index != -1) {
      final old = all[index];
      all[index] = HealthRecordEntry(
        id: record.id,
        dateLabel: record.dateLabel,
        condition: record.condition,
        vitals: record.vitals,
        note: record.note,
        attachmentPath: record.attachmentPath,
        date: record.date,
        source: record.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: record.deletedAt,
        entityVersion: old.entityVersion + 1,
      );
    } else {
      all.insert(0, record);
    }
    await _save(all);
  }

  @override
  Future<void> deleteRecord(String id) async {
    final List<HealthRecordEntry> all = await BackgroundService.decodeRecords(_prefs.getString(_key));
    final int index = all.indexWhere((e) => e.id == id);
    if (index != -1) {
      final old = all[index];
      all[index] = HealthRecordEntry(
        id: old.id,
        dateLabel: old.dateLabel,
        condition: old.condition,
        vitals: old.vitals,
        note: old.note,
        attachmentPath: old.attachmentPath,
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

  Future<void> _save(List<HealthRecordEntry> list) async {
    final String jsonStr = jsonEncode(list.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, jsonStr);
  }
}
