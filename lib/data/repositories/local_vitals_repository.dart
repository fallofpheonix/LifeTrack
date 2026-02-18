import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/data/repository/vitals_repository.dart';
import '../models/vitals/blood_pressure_entry.dart';
import '../models/vitals/heart_rate_entry.dart';
import '../models/vitals/glucose_entry.dart';
import '../models/weight_entry.dart';
import '../../core/services/background_service.dart';

class LocalVitalsRepository implements VitalsRepository {
  static const String _bpKey = 'lifetrack_bp_v2'; // v2 for clean schema
  static const String _hrKey = 'lifetrack_hr_v2';
  static const String _glucoseKey = 'lifetrack_glucose_v2';
  static const String _weightKey = 'lifetrack_weight_v2';

  final SharedPreferences _prefs;

  LocalVitalsRepository(this._prefs);

  // --- Blood Pressure ---

  @override
  Future<List<BloodPressureEntry>> getBP({DateTime? start, DateTime? end, bool includeDeleted = false}) async {
    final List<BloodPressureEntry> all = await BackgroundService.decodeBP(_prefs.getString(_bpKey));
    return all.where((BloodPressureEntry e) {
      if (!includeDeleted && e.deletedAt != null) return false;
      if (start != null && e.date.isBefore(start)) return false;
      if (end != null && e.date.isAfter(end)) return false;
      return true;
    }).toList();
  }

  @override
  Future<void> saveBP(BloodPressureEntry entry) async {
    final List<BloodPressureEntry> all = await BackgroundService.decodeBP(_prefs.getString(_bpKey));
    final int index = all.indexWhere((e) => e.id == entry.id);
    
    if (index != -1) {
      final BloodPressureEntry old = all[index];
      // Increment version if updating
      final updated = BloodPressureEntry(
        id: entry.id,
        systolic: entry.systolic,
        diastolic: entry.diastolic,
        date: entry.date,
        source: entry.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: entry.deletedAt,
        entityVersion: old.entityVersion + 1,
      );
      all[index] = updated;
    } else {
      all.insert(0, entry);
    }
    
    _sortDescending(all, (BloodPressureEntry e) => e.date);
    await _saveList(_bpKey, all);
  }

  @override
  Future<void> deleteBP(String id) async {
    final List<BloodPressureEntry> all = await BackgroundService.decodeBP(_prefs.getString(_bpKey));
    final int index = all.indexWhere((e) => e.id == id);
    if (index != -1) {
       final BloodPressureEntry old = all[index];
       final BloodPressureEntry deleted = BloodPressureEntry(
         id: old.id,
         systolic: old.systolic,
         diastolic: old.diastolic,
         date: old.date,
         source: old.source,
         createdAt: old.createdAt,
         editedAt: DateTime.now().toUtc(),
         deletedAt: DateTime.now().toUtc(), // Set deletedAt
         entityVersion: old.entityVersion + 1,
       );
       all[index] = deleted;
       await _saveList(_bpKey, all);
    }
  }

  // --- Heart Rate ---

  @override
  Future<List<HeartRateEntry>> getHeartRate({DateTime? start, DateTime? end, bool includeDeleted = false}) async {
    final List<HeartRateEntry> all = await BackgroundService.decodeHR(_prefs.getString(_hrKey));
    return _filterByDate(all, (HeartRateEntry e) => e.date, start, end)
        .where((e) => includeDeleted || e.deletedAt == null)
        .toList();
  }

  @override
  Future<void> saveHeartRate(HeartRateEntry entry) async {
    final List<HeartRateEntry> all = await BackgroundService.decodeHR(_prefs.getString(_hrKey));
    final int index = all.indexWhere((e) => e.id == entry.id);
    
    if (index != -1) {
      final HeartRateEntry old = all[index];
      final updated = HeartRateEntry(
        id: entry.id,
        bpm: entry.bpm,
        date: entry.date,
        source: entry.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: entry.deletedAt,
        entityVersion: old.entityVersion + 1,
      );
      all[index] = updated;
    } else {
      all.add(entry);
    }
    _sortDescending(all, (HeartRateEntry e) => e.date);
    await _saveList(_hrKey, all);
  }

  @override
  Future<void> deleteHeartRate(String id) async {
    final List<HeartRateEntry> all = await BackgroundService.decodeHR(_prefs.getString(_hrKey));
    final int index = all.indexWhere((e) => e.id == id);
    if (index != -1) {
      final HeartRateEntry old = all[index];
      final HeartRateEntry deleted = HeartRateEntry(
        id: old.id,
        bpm: old.bpm,
        date: old.date,
        source: old.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: DateTime.now().toUtc(),
        entityVersion: old.entityVersion + 1,
      );
      all[index] = deleted;
      await _saveList(_hrKey, all);
    }
  }

  // --- Glucose ---

  @override
  Future<List<GlucoseEntry>> getGlucose({DateTime? start, DateTime? end, bool includeDeleted = false}) async {
    final List<GlucoseEntry> all = await BackgroundService.decodeGlucose(_prefs.getString(_glucoseKey));
    return _filterByDate(all, (GlucoseEntry e) => e.date, start, end)
        .where((e) => includeDeleted || e.deletedAt == null)
        .toList();
  }

  @override
  Future<void> saveGlucose(GlucoseEntry entry) async {
    final List<GlucoseEntry> all = await BackgroundService.decodeGlucose(_prefs.getString(_glucoseKey));
    final int index = all.indexWhere((e) => e.id == entry.id);

    if (index != -1) {
      final GlucoseEntry old = all[index];
      final updated = GlucoseEntry(
        id: entry.id,
        levelMgDl: entry.levelMgDl,
        context: entry.context,
        date: entry.date,
        source: entry.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: entry.deletedAt,
        entityVersion: old.entityVersion + 1,
      );
      all[index] = updated;
    } else {
      all.add(entry);
    }
    _sortDescending(all, (GlucoseEntry e) => e.date);
    await _saveList(_glucoseKey, all);
  }

  @override
  Future<void> deleteGlucose(String id) async {
    final List<GlucoseEntry> all = await BackgroundService.decodeGlucose(_prefs.getString(_glucoseKey));
    final int index = all.indexWhere((e) => e.id == id);
    if (index != -1) {
      final GlucoseEntry old = all[index];
      final GlucoseEntry deleted = GlucoseEntry(
        id: old.id,
        levelMgDl: old.levelMgDl,
        context: old.context,
        date: old.date,
        source: old.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: DateTime.now().toUtc(),
        entityVersion: old.entityVersion + 1,
      );
      all[index] = deleted;
      await _saveList(_glucoseKey, all);
    }
  }

  // --- Weight ---

  @override
  Future<List<WeightEntry>> getWeight({DateTime? start, DateTime? end, bool includeDeleted = false}) async {
    final List<WeightEntry> all = await BackgroundService.decodeWeight(_prefs.getString(_weightKey));
    return _filterByDate(all, (WeightEntry e) => e.date, start, end)
        .where((e) => includeDeleted || e.deletedAt == null)
        .toList();
  }

  @override
  Future<void> saveWeight(WeightEntry entry) async {
    final List<WeightEntry> all = await BackgroundService.decodeWeight(_prefs.getString(_weightKey));
    
    // WeightEntries don't have ID, they are unique by Date (day level usually, but here strict DateTime)
    // Assuming 2 entries same exact second is weird, but let's assume strict equality or add logic?
    // The previous implementation used DateTime equality in delete, so let's use that for upsert too?
    // Actually, WeightEntry doesn't have an ID field in the model I saw? 
    // Checking previous file view... WeightEntry has NO ID parameter!
    // So we search by approximate time? or just exact time.
    // If exact time matches, we update.
    
    final int index = all.indexWhere((e) => e.date == entry.date); // Strict equality
    
    if (index != -1) {
       final WeightEntry old = all[index];
       final updated = WeightEntry(
         date: entry.date,
         weightKg: entry.weightKg,
         source: entry.source,
         createdAt: old.createdAt,
         editedAt: DateTime.now().toUtc(),
         deletedAt: entry.deletedAt,
         entityVersion: old.entityVersion + 1,
       );
       all[index] = updated;
    } else {
       all.add(entry);
    }
    _sortDescending(all, (WeightEntry e) => e.date);
    await _saveList(_weightKey, all);
  }

  @override
  Future<void> deleteWeight(DateTime date) async {
    final List<WeightEntry> all = await BackgroundService.decodeWeight(_prefs.getString(_weightKey));
    final int index = all.indexWhere((e) =>
      e.date.year == date.year && e.date.month == date.month && e.date.day == date.day
    );
    if (index != -1) {
      final WeightEntry old = all[index];
      final WeightEntry deleted = WeightEntry(
        date: old.date,
        weightKg: old.weightKg,
        source: old.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: DateTime.now().toUtc(),
        entityVersion: old.entityVersion + 1,
      );
      all[index] = deleted;
      await _saveList(_weightKey, all);
    }
  }

  // --- Helpers ---



  Future<void> _saveList<T>(String key, List<T> list) async {
    // Assuming T has toJson(). Since generics don't enforce it easily in Dart without mixin,
    // we rely on dynamic dispatch or knowing the types.
    // For safety, we'll cast to dynamic and call toJson.
    final String jsonStr = jsonEncode(list.map((dynamic e) => e.toJson()).toList());
    await _prefs.setString(key, jsonStr);
  }

  void _sortDescending<T>(List<T> list, DateTime Function(T) getDate) {
    list.sort((T a, T b) => getDate(b).compareTo(getDate(a)));
  }

  List<T> _filterByDate<T>(List<T> list, DateTime Function(T) getDate, DateTime? start, DateTime? end) {
    if (start == null && end == null) return list;
    return list.where((T e) {
      final DateTime d = getDate(e);
      if (start != null && d.isBefore(start)) return false;
      if (end != null && d.isAfter(end)) return false;
      return true;
    }).toList();
  }
}
