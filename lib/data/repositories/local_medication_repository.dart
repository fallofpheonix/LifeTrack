import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lifetrack/core/data/repository/medication_repository.dart';
import 'package:lifetrack/data/models/medication/medication.dart';
import 'package:lifetrack/data/models/medication/dose_log.dart';

class LocalMedicationRepository implements MedicationRepository {
  static const String _medsKey = 'lifetrack_meds_v1';
  static const String _dosesKey = 'lifetrack_doses_v1';

  final SharedPreferences _prefs;

  LocalMedicationRepository(this._prefs);

  @override
  Future<List<Medication>> getMedications({bool includeDeleted = false}) async {
    final List<Medication> all = _decodeList(
      _prefs.getString(_medsKey),
      (Map<String, dynamic> json) => Medication.fromJson(json),
    );
    return all.where((m) => includeDeleted || m.deletedAt == null).toList();
  }

  @override
  Future<void> saveMedication(Medication medication) async {
    final List<Medication> all = await _getRawMedications();
    // Update if exists, else add
    final int index = all.indexWhere((Medication m) => m.id == medication.id);
    if (index != -1) {
      final Medication old = all[index];
      final updated = Medication(
        id: medication.id,
        name: medication.name,
        dosage: medication.dosage,
        frequencyType: medication.frequencyType,
        intervalHours: medication.intervalHours,
        startDate: medication.startDate,
        source: medication.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: medication.deletedAt,
        entityVersion: old.entityVersion + 1,
      );
      all[index] = updated; 
    } else {
      all.add(medication);
    }
    await _saveList(_medsKey, all);
  }

  Future<List<Medication>> _getRawMedications() async {
     return _decodeList(
      _prefs.getString(_medsKey),
      (Map<String, dynamic> json) => Medication.fromJson(json),
    );
  }

  @override
  Future<void> deleteMedication(String id) async {
    final List<Medication> all = await _getRawMedications();
    final int index = all.indexWhere((Medication m) => m.id == id);
    if (index != -1) {
      final Medication old = all[index];
      final Medication deleted = Medication(
        id: old.id,
        name: old.name,
        dosage: old.dosage,
        frequencyType: old.frequencyType,
        intervalHours: old.intervalHours,
        startDate: old.startDate,
        source: old.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: DateTime.now().toUtc(),
        entityVersion: old.entityVersion + 1,
      );
      all[index] = deleted;
      await _saveList(_medsKey, all);
    }
  }

  @override
  Future<List<DoseLog>> getDoseLogs({DateTime? start, DateTime? end, bool includeDeleted = false}) async {
    final List<DoseLog> all = _decodeList(
      _prefs.getString(_dosesKey),
      (Map<String, dynamic> json) => DoseLog.fromJson(json),
    );
    
    final List<DoseLog> active = all.where((l) => includeDeleted || l.deletedAt == null).toList();

    if (start == null && end == null) {
      // Return sorted by time descending by default
      active.sort((DoseLog a, DoseLog b) => b.scheduledTime.compareTo(a.scheduledTime));
      return active;
    }

    final List<DoseLog> filtered = active.where((DoseLog l) {
      if (start != null && l.scheduledTime.isBefore(start)) return false;
      if (end != null && l.scheduledTime.isAfter(end)) return false;
      return true;
    }).toList();

    filtered.sort((DoseLog a, DoseLog b) => b.scheduledTime.compareTo(a.scheduledTime));
    return filtered;
  }

  @override
  Future<void> logDose(DoseLog log) async {
    final List<DoseLog> fullList = _decodeList(
      _prefs.getString(_dosesKey),
      (Map<String, dynamic> json) => DoseLog.fromJson(json),
    );

    // Check if updating existing log (e.g. changing status)
    final int index = fullList.indexWhere((d) => d.id == log.id);
    if (index != -1) {
       final DoseLog old = fullList[index];
       final updated = DoseLog(
         id: log.id,
         medicationId: log.medicationId,
         scheduledTime: log.scheduledTime,
         takenTime: log.takenTime,
         status: log.status,
         source: log.source,
         createdAt: old.createdAt,
         editedAt: DateTime.now().toUtc(),
         deletedAt: log.deletedAt,
         entityVersion: old.entityVersion + 1,
       );
       fullList[index] = updated;
    } else {
       fullList.add(log);
    }
    await _saveList(_dosesKey, fullList);
  }

  @override
  Future<void> deleteDoseLog(String id) async {
    final List<DoseLog> fullList = _decodeList(
      _prefs.getString(_dosesKey),
      (Map<String, dynamic> json) => DoseLog.fromJson(json),
    );
    final int index = fullList.indexWhere((DoseLog l) => l.id == id);
    if (index != -1) {
      final DoseLog old = fullList[index];
      final DoseLog deleted = DoseLog(
        id: old.id,
        medicationId: old.medicationId,
        scheduledTime: old.scheduledTime,
        takenTime: old.takenTime,
        status: old.status,
        source: old.source,
        createdAt: old.createdAt,
        editedAt: DateTime.now().toUtc(),
        deletedAt: DateTime.now().toUtc(),
        entityVersion: old.entityVersion + 1,
      );
      fullList[index] = deleted;
      await _saveList(_dosesKey, fullList);
    }
  }

  // --- Helpers ---

  List<T> _decodeList<T>(String? jsonStr, T Function(Map<String, dynamic>) fromJson) {
    if (jsonStr == null || jsonStr.isEmpty) return <T>[];
    try {
      final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((dynamic e) => fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return <T>[];
    }
  }

  Future<void> _saveList<T>(String key, List<T> list) async {
    final String jsonStr = jsonEncode(list.map((dynamic e) => e.toJson()).toList());
    await _prefs.setString(key, jsonStr);
  }
}
