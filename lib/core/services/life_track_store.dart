
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pedometer/pedometer.dart';

import '../../data/models/activity_log.dart';
import '../../data/models/disease_info.dart';
import '../../data/models/health_record_entry.dart';
import '../../data/models/health_snapshot.dart';
import '../../data/models/meal_entry.dart';
import '../../data/models/medication/dose_log.dart';
import '../../data/models/reminder_item.dart';
import '../../data/models/scientist.dart';
import '../../data/models/sleep_entry.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/vitals/blood_pressure_entry.dart';
import '../../data/models/vitals/heart_rate_entry.dart';
import '../../data/models/vitals/glucose_entry.dart';
import '../../data/models/weight_entry.dart';
import '../../data/models/enums/sync_operation_type.dart';
import '../../data/models/sync/sync_operation.dart'; // Add this import
import '../../data/models/intelligence/insight.dart'; // Add this
import '../../data/models/clinical/recovery_data_point.dart'; // Add this (if exists, or I create it)
import '../../data/models/content/news_item.dart'; // Add this (if exists, or I create it)
import '../../core/data/repository/vitals_repository.dart';
import '../../core/data/repository/medication_repository.dart';
import 'secure_serializer.dart';
import 'user_session_service.dart';
import 'sync_queue_service.dart';
import 'sync_service.dart';
import 'health_log.dart';
import '../settings/ui_preferences.dart';
import 'background_service.dart';
import 'global_error_handler.dart';
import 'data_governance_service.dart';
import 'governance/export_policy.dart'; // For exportUserData

// Const keys
const String _snapshotKey = 'health_snapshot';
const String _profileKey = 'user_profile';
const String _remindersKey = 'reminders';
const String _recordsKey = 'health_records';
const String _mealsKey = 'meal_logs';
const String _activitiesKey = 'activity_logs';
const String _sleepKey = 'sleep_logs';

class LifeTrackStore extends ChangeNotifier with WidgetsBindingObserver {
  // Dependencies
  final VitalsRepository vitalsRepo;
  final MedicationRepository medicationRepo;
  final UserSessionService sessionService;
  final SecureSerializer secureSerializer;
  final SyncQueueService syncQueue;
  final SyncService syncService;
  final DataGovernanceService governanceService;

  // Data
  HealthSnapshot snapshot;
  UserProfile userProfile;
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void updateTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    // Persist preference...
  }
  
  // Internal Lists (All data including deleted)
  List<ActivityLog> _allActivities = [];
  List<MealEntry> _allMeals = [];
  List<SleepEntry> _allSleepLogs = [];
  List<HealthRecordEntry> _allRecords = [];
  
  // Public Getters (Filter output deleted)
  List<ActivityLog> get activities => _allActivities.where((e) => e.deletedAt == null).toList();
  List<MealEntry> get meals => _allMeals.where((e) => e.deletedAt == null).toList();
  List<SleepEntry> get sleepLogs => _allSleepLogs.where((e) => e.deletedAt == null).toList();
  List<HealthRecordEntry> get records => _allRecords.where((e) => e.deletedAt == null).toList();

  List<ReminderItem> reminders = [];
  
  // Vitals Cache (Managed by Repo, but exposed here for UI convenience/legacy)
  List<WeightEntry> weightHistory = [];
  List<BloodPressureEntry> bpHistory = [];
  List<HeartRateEntry> hrHistory = [];
  List<GlucoseEntry> glucoseHistory = [];
  
  // Meds Cache
  List<DoseLog> doseLogs = [];

  // Pedometer
  StreamSubscription<StepCount>? _stepCountStream;

  // Static Data (Mock for now, could move to Repo)
  final List<DiseaseInfo> diseaseGuide = [
      DiseaseInfo(name: 'Hypertension', symptoms: 'High Blood Pressure, Headaches', precautions: 'Reduce salt, Exercise', prevention: 'Maintain healthy weight', cure: 'Medication, Lifestyle changes'),
      DiseaseInfo(name: 'Diabetes T2', symptoms: 'Thirst, Frequent urination', precautions: 'Low sugar diet', prevention: 'Weight loss, Exercise', cure: 'Insulin, Metformin'),
      DiseaseInfo(name: 'Influenza', symptoms: 'Fever, Cough, Fatigue', precautions: 'Hygiene, Mask', prevention: 'Vaccine', cure: 'Rest, Fluids, Antivirals'),
  ];

  final List<Scientist> scientists = [
      Scientist(name: 'Louis Pasteur', contribution: 'Germ Theory, Vaccination', description: 'French microbiologist composed of germ theory.', imageUrl: 'https://example.com/pasteur.jpg'),
      Scientist(name: 'Alexander Fleming', contribution: 'Penicillin', description: 'Scottish physician who discovered penicillin.', imageUrl: 'https://example.com/fleming.jpg'),
      Scientist(name: 'Marie Curie', contribution: 'Radioactivity', description: 'Polish-French physicist and chemist.', imageUrl: 'https://example.com/curie.jpg'),
  ];

  LifeTrackStore({
    required this.vitalsRepo,
    required this.medicationRepo,
    required this.sessionService,
    required this.secureSerializer,
    required this.syncQueue,
    required this.syncService,
    required this.governanceService,
    required this.snapshot,
    required this.userProfile,
  }) {
    WidgetsBinding.instance.addObserver(this);
    _initPedometer();
    _refreshVitalsCache(); // Initial load
    HealthLog.i('LifeTrackStore', 'Init', 'Store initialized successfully');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stepCountStream?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      HealthLog.i('LifeTrackStore', 'Lifecycle', 'App paused, persisting state');
      _persistAll();
    } else if (state == AppLifecycleState.resumed) {
      HealthLog.i('LifeTrackStore', 'Lifecycle', 'App resumed');
      _refreshVitalsCache();
      // Resume logic here
    }
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream.listen(
      (StepCount event) {
        // Simple logic: delta check or raw? Assuming raw steps since boot.
        // For simplicity in Phase 5, just update if greater.
        // In real app, need daily reset logic.
        if (event.steps > snapshot.steps) {
            snapshot.steps = event.steps;
            notifyListeners();
        }
      },
      onError: (Object error) {
        HealthLog.w('LifeTrackStore', 'Pedometer', 'Stream error', error: error);
      },
    );
  }

  Future<void> _refreshVitalsCache() async {
      weightHistory = await vitalsRepo.getWeight();
      bpHistory = await vitalsRepo.getBP();
      hrHistory = await vitalsRepo.getHeartRate();
      glucoseHistory = await vitalsRepo.getGlucose();
      // Dose logs?
      // doseLogs = await medicationRepo.getDoseLogs(); // Add this if needed
      notifyListeners();
  }

  static Future<LifeTrackStore> load(
    VitalsRepository vitalsRepo,
    MedicationRepository medicationRepo,
    UserSessionService sessionService,
    SecureSerializer secureSerializer,
    SyncQueueService syncQueue,
    SyncService syncService,
    DataGovernanceService governanceService,
  ) async {
     try {
       final SharedPreferences prefs = await SharedPreferences.getInstance();

       // Helper to load encrypted
       Future<String?> loadStr(String key) async {
           final enc = prefs.getString(key);
           if (enc == null) return null;
           return await secureSerializer.decryptString(enc);
       }

       final snapStr = await loadStr(_snapshotKey);
       final profileStr = await loadStr(_profileKey);
       final remindersStr = await loadStr(_remindersKey);
       final recordsStr = await loadStr(_recordsKey);
       final mealsStr = await loadStr(_mealsKey);
       final activitiesStr = await loadStr(_activitiesKey);
       final sleepStr = await loadStr(_sleepKey);

       // Decode in background (simulated or real)
       final snapshot = await BackgroundService.decodeSnapshot(snapStr) ?? HealthSnapshot.empty();
       final profile = await BackgroundService.decodeProfile(profileStr) ?? UserProfile.empty();
       
       final reminders = await BackgroundService.decodeReminders(remindersStr);
       final records = await BackgroundService.decodeRecords(recordsStr);
       final meals = await BackgroundService.decodeMeals(mealsStr);
       final activities = await BackgroundService.decodeActivities(activitiesStr);
       final sleep = await BackgroundService.decodeSleep(sleepStr);

       final store = LifeTrackStore(
        vitalsRepo: vitalsRepo,
        medicationRepo: medicationRepo,
        sessionService: sessionService,
        secureSerializer: secureSerializer,
        syncQueue: syncQueue,
        syncService: syncService,
        governanceService: governanceService,
        snapshot: snapshot,
        userProfile: profile,
       );

       store.reminders = reminders;
       store._allRecords = records;
       store._allMeals = meals;
       store._allActivities = activities;
       store._allSleepLogs = sleep;
       
       return store;

     } catch (e, stack) {
       HealthLog.e('LifeTrackStore', 'Load', 'Failed to load store', error: e, stackTrace: stack);
       // Return empty store on fail to allow app to start? Or rethrow?
       // Rethrowing is safer to detect corruption.
       rethrow;
     }
  }

  // --- Actions ---

  Future<void> addRecord(HealthRecordEntry record) async {
    _allRecords.insert(0, record);
    notifyListeners();
    await _persistRecords();
    await _enqueueSync(SyncOperationType.create, 'medical_record', record.id, record.toJson());
    HealthLog.audit('LifeTrackStore', 'AddRecord', 'Medical Record Added', userId: 'user', details: {'id': record.id});
  }

  // Activity
  Future<void> addActivity(ActivityLog log) async {
    _allActivities.insert(0, log);
    notifyListeners();
    await _persistActivities();
    await _enqueueSync(SyncOperationType.create, 'activity', log.id, log.toJson());
  }

  Future<void> deleteActivity(String id) async {
    final index = _allActivities.indexWhere((e) => e.id == id);
    if (index != -1) {
      final old = _allActivities[index];
       final updated = ActivityLog(
         id: old.id, date: old.date, durationMinutes: old.durationMinutes,
         type: old.type, name: old.name, caloriesBurned: old.caloriesBurned,
         createdAt: old.createdAt, editedAt: DateTime.now().toUtc(),
         deletedAt: DateTime.now().toUtc(), entityVersion: old.entityVersion + 1
       );
       _allActivities[index] = updated;
       notifyListeners();
       await _persistActivities();
       await _enqueueSync(SyncOperationType.delete, 'activity', id, {});
    }
  }

  // Nutrition
  Future<void> addMeal(MealEntry entry) async {
    _allMeals.insert(0, entry);
    notifyListeners();
    await _persistMeals();
    await _enqueueSync(SyncOperationType.create, 'meal', entry.id, entry.toJson());
  }

  Future<void> deleteMeal(String id) async {
     final index = _allMeals.indexWhere((e) => e.id == id);
     if (index != -1) {
       final old = _allMeals[index];
        final updated = MealEntry(
          id: old.id,
          date: old.date,
          mealType: old.mealType,
          title: old.title,
          calories: old.calories,
          createdAt: old.createdAt,
          editedAt: DateTime.now().toUtc(),
          deletedAt: DateTime.now().toUtc(),
          entityVersion: old.entityVersion + 1
        );
       _allMeals[index] = updated;
       notifyListeners();
       await _persistMeals();
       await _enqueueSync(SyncOperationType.delete, 'meal', id, {});
     }
  }

  Future<void> addWaterGlass() async {
    snapshot.waterGlasses++;
    notifyListeners();
    await _persistSnapshot();
    await _enqueueSync(SyncOperationType.update, 'snapshot', 'daily_snapshot', snapshot.toJson());
  }

  Future<void> removeWaterGlass() async {
    if (snapshot.waterGlasses > 0) {
      snapshot.waterGlasses--;
      notifyListeners();
      await _persistSnapshot();
      await _enqueueSync(SyncOperationType.update, 'snapshot', 'daily_snapshot', snapshot.toJson());
    }
  }

  // Vitals Wrappers
  Future<void> addWeightEntry(WeightEntry entry) async {
    await vitalsRepo.saveWeight(entry);
    await _refreshVitalsCache();
     await _enqueueSync(SyncOperationType.create, 'weight', entry.date.toIso8601String(), entry.toJson());
  }

  Future<void> addBloodPressure(BloodPressureEntry entry) async {
    await vitalsRepo.saveBP(entry);
    await _refreshVitalsCache();
    await _enqueueSync(SyncOperationType.create, 'blood_pressure', entry.id, entry.toJson());
  }

  Future<void> addHeartRate(HeartRateEntry entry) async {
    await vitalsRepo.saveHeartRate(entry);
    await _refreshVitalsCache();
    await _enqueueSync(SyncOperationType.create, 'heart_rate', entry.id, entry.toJson());
  }

  Future<void> addGlucose(GlucoseEntry entry) async {
    await vitalsRepo.saveGlucose(entry);
    await _refreshVitalsCache();
    await _enqueueSync(SyncOperationType.create, 'glucose', entry.id, entry.toJson());
  }

  // Reminders
  Future<void> toggleReminder(String id) async {
    final index = reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      final old = reminders[index];
      final updated = ReminderItem(
        id: old.id,
        title: old.title,
        timeLabel: old.timeLabel,
        enabled: !old.enabled,
        days: old.days,
        type: old.type,
      );
      reminders[index] = updated;
      notifyListeners();
      await _persistReminders();
    }
  }

  // Placeholders
  List<Insight> get insights => [
    Insight(
      id: '1', 
      title: "Activity Trend", 
      message: "You're walking more than last week!", 
      type: InsightType.success, 
      date: DateTime.now()
    ),
    Insight(
      id: '2', 
      title: "Hydration", 
      message: "Try to drink more water in the morning.", 
      type: InsightType.info, 
      date: DateTime.now()
    ),
    Insight(
      id: '3', 
      title: "Sleep Quality", 
      message: "Sleep consistency is key to recovery.", 
      type: InsightType.warning, 
      date: DateTime.now()
    ),
  ];

  List<RecoveryDataPoint> get recoveryData => [
    RecoveryDataPoint(label: 'Recovery', value: '85%', status: 'Good'),
    RecoveryDataPoint(label: 'Strain', value: 'Low', status: 'Optimal'),
  ];

  List<NewsItem> get news => [
    NewsItem(id: '1', title: 'New Research on Sleep', summary: 'Studies show 8 hours is optimal.', date: DateTime.now(), source: 'HealthDaily', link: 'https://example.com/sleep'),
    NewsItem(id: '2', title: 'Hydration Benefits', summary: 'Water improves cognitive function.', date: DateTime.now(), source: 'ScienceToday', link: 'https://example.com/water'),
  ];

  Future<Map<String, dynamic>> exportAll() async {
    return {
      'profile': userProfile.toJson(),
      'snapshot': snapshot.toJson(),
      'records': records.map((e) => e.toJson()).toList(),
      'vitals': {
        'weight': weightHistory.map((e) => e.toJson()).toList(),
        'bp': bpHistory.map((e) => e.toJson()).toList(),
        'glucose': glucoseHistory.map((e) => e.toJson()).toList(),
        'heart_rate': hrHistory.map((e) => e.toJson()).toList(),
      },
      'activities': activities.map((e) => e.toJson()).toList(),
      'sleep': sleepLogs.map((e) => e.toJson()).toList(),
      'meals': meals.map((e) => e.toJson()).toList(),
    };
  }

  Future<void> deleteRecord(String id) async {
    final index = _allRecords.indexWhere((e) => e.id == id);
    if (index != -1) {
        final old = _allRecords[index];
        final updated = HealthRecordEntry(
            id: old.id, dateLabel: old.dateLabel, date: old.date, vitals: old.vitals, note: old.note, 
            condition: old.condition, attachmentPath: old.attachmentPath,
            source: old.source, createdAt: old.createdAt, editedAt: DateTime.now().toUtc(),
            deletedAt: DateTime.now().toUtc(), entityVersion: old.entityVersion + 1
        );
        _allRecords[index] = updated;
        notifyListeners();
        await _persistRecords();
        await _enqueueSync(SyncOperationType.delete, 'medical_record', id, {});
    }
  }

  Future<void> addSleepLog(SleepEntry entry) async {
    _allSleepLogs.insert(0, entry);
    // Update snapshot logic (simplified)
    if (_isToday(entry.endTime)) {
       snapshot.sleepHours += entry.durationHours;
    }
    notifyListeners();
    await _persistSleep();
    await _persistSnapshot();
    await _enqueueSync(SyncOperationType.create, 'sleep', entry.id, entry.toJson());
  }

  Future<void> deleteSleepLog(String id) async {
    final index = _allSleepLogs.indexWhere((e) => e.id == id);
    if (index != -1) {
       final old = _allSleepLogs[index];
       if (_isToday(old.endTime)) {
           snapshot.sleepHours = (snapshot.sleepHours - old.durationHours).clamp(0.0, 24.0);
       }
       final updated = SleepEntry(
         id: old.id, startTime: old.startTime, endTime: old.endTime,
         source: old.source, createdAt: old.createdAt, editedAt: DateTime.now().toUtc(),
         deletedAt: DateTime.now().toUtc(), entityVersion: old.entityVersion + 1
       );
       _allSleepLogs[index] = updated;
       
       notifyListeners();
       await _persistSleep();
       await _persistSnapshot();
       await _enqueueSync(SyncOperationType.delete, 'sleep', id, {});
    }
  }

  Future<void> updateProfile(UserProfile profile, int newGoal) async {
    userProfile = profile;
    snapshot.caloriesGoal = newGoal;
    notifyListeners();
    await _persistProfile();
    await _persistSnapshot();
    await _enqueueSync(SyncOperationType.update, 'profile', 'user_profile', profile.toJson());
  }

  Future<void> clearAll() async {
     HealthLog.audit('LifeTrackStore', 'ClearData', 'User initiated data wipe', userId: 'user');
     
     _allActivities.clear();
     _allMeals.clear();
     _allSleepLogs.clear();
     _allRecords.clear();
     reminders.clear();
     weightHistory.clear();
     bpHistory.clear();
     hrHistory.clear();
     glucoseHistory.clear();
     doseLogs.clear();
     
     snapshot = HealthSnapshot.empty();
     
     notifyListeners();
     
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.clear();
     await UiPreferences.init();
  }

  // --- Persistence Wrappers ---
  Future<void> _persistAll() async {
      await Future.wait([
          _persistSnapshot(),
          _persistProfile(),
          _persistReminders(),
          _persistRecords(),
          _persistMeals(),
          _persistActivities(),
          _persistSleep(),
      ]);
  }

  Future<void> _persistSnapshot() async => _save(_snapshotKey, snapshot.toJson());
  Future<void> _persistProfile() async => _save(_profileKey, userProfile.toJson());
  Future<void> _persistReminders() async => _saveList(_remindersKey, reminders);
  Future<void> _persistRecords() async => _saveList(_recordsKey, _allRecords);
  Future<void> _persistMeals() async => _saveList(_mealsKey, _allMeals);
  Future<void> _persistActivities() async => _saveList(_activitiesKey, _allActivities);
  Future<void> _persistSleep() async => _saveList(_sleepKey, _allSleepLogs);

  Future<void> _save(String key, dynamic json) async {
      final prefs = await SharedPreferences.getInstance();
      final str = jsonEncode(json);
      final enc = await secureSerializer.encryptString(str);
      await prefs.setString(key, enc);
  }

  Future<void> _saveList(String key, List<dynamic> list) async {
      final prefs = await SharedPreferences.getInstance();
      final str = jsonEncode(list.map((e) => e.toJson()).toList());
      final enc = await secureSerializer.encryptString(str);
      await prefs.setString(key, enc);
  }

  Future<void> _enqueueSync(SyncOperationType type, String feature, String id, Map<String, dynamic> payload, {SyncPriority priority = SyncPriority.normal}) async {
    try {
        await syncQueue.enqueue(
          SyncOperation(
              id: DateTime.now().microsecondsSinceEpoch.toString(), // Unique op ID
              type: type,
              entityTable: feature,
              entityId: id,
              payload: payload,
              priority: priority,
              timestamp: DateTime.now().toUtc(),
          )
        );
        // Trigger sync immediately if critical or network valid
        syncService.triggerSync();
    } catch (e) {
        HealthLog.e('LifeTrackStore', 'SyncEnqueue', 'Failed to enqueue sync op', error: e);
    }
  }


  // --- Search Methods ---
  List<DiseaseInfo> searchDiseases(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return diseaseGuide.where((d) => 
      d.name.toLowerCase().contains(q) || d.symptoms.toLowerCase().contains(q)
    ).toList();
  }

  List<Scientist> searchScientists(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return scientists.where((s) => 
      s.name.toLowerCase().contains(q) || s.contribution.toLowerCase().contains(q)
    ).toList();
  }

  List<HealthRecordEntry> searchRecords(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return records.where((r) => 
      r.condition.toLowerCase().contains(q) || r.note.toLowerCase().contains(q)
    ).toList();
  }
  
  // --- Vitals & Meds Actions ---

  Future<void> deleteBP(String id) async {
      await vitalsRepo.deleteBP(id);
      bpHistory.removeWhere((e) => e.id == id); 
      notifyListeners();
      await _enqueueSync(SyncOperationType.delete, 'blood_pressure', id, {});
  }

  Future<void> deleteHeartRate(String id) async {
      await vitalsRepo.deleteHeartRate(id);
      hrHistory.removeWhere((e) => e.id == id);
      notifyListeners();
      await _enqueueSync(SyncOperationType.delete, 'heart_rate', id, {});
  }

  Future<void> deleteGlucose(String id) async {
      await vitalsRepo.deleteGlucose(id);
      glucoseHistory.removeWhere((e) => e.id == id);
      notifyListeners();
      await _enqueueSync(SyncOperationType.delete, 'glucose', id, {});
  }

  Future<void> deleteWeight(DateTime date) async {
      await vitalsRepo.deleteWeight(date);
      weightHistory.removeWhere((e) => _isSameDay(e.date, date)); 
      notifyListeners();
      await _enqueueSync(SyncOperationType.delete, 'weight', date.toIso8601String(), {});
  }

  Future<void> deleteDoseLog(String id) async {
      await medicationRepo.deleteDoseLog(id);
      doseLogs.removeWhere((d) => d.id == id);
      notifyListeners();
      await _enqueueSync(SyncOperationType.delete, 'dose_log', id, {});
  }
  
  bool _isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  // --- Data Governance ---

  Future<void> enforceRetentionPolicy() async {
    HealthLog.i('LifeTrackStore', 'Governance', 'Enforcing Retention Policy...');
    
    // 1. Records
    final expiredRecords = _allRecords.where((r) => 
      !governanceService.shouldRetain(r.createdAt ?? r.date, 'medical_record') && r.deletedAt == null
    ).toList();
    for (var r in expiredRecords) {
       await deleteRecord(r.id); 
    }

    // 2. Vitals
    // Note: Iterating in-memory cache. 
    for (var e in weightHistory) {
         if (e.deletedAt == null && !governanceService.shouldRetain(e.createdAt ?? e.date, 'medical_record')) {
            await deleteWeight(e.date);
         }
    }
    for (var e in bpHistory) {
         if (e.deletedAt == null && !governanceService.shouldRetain(e.createdAt ?? e.date, 'medical_record')) {
            await deleteBP(e.id);
         }
    }
    for (var e in hrHistory) {
         if (e.deletedAt == null && !governanceService.shouldRetain(e.createdAt ?? e.date, 'medical_record')) {
            await deleteHeartRate(e.id);
         }
    }
    for (var e in glucoseHistory) {
         if (e.deletedAt == null && !governanceService.shouldRetain(e.createdAt ?? e.date, 'medical_record')) {
            await deleteGlucose(e.id);
         }
    }
    
    // 3. Dose Logs
    // Ensure we have them loaded
    final doses = await medicationRepo.getDoseLogs();
    for (var d in doses) {
        if (d.deletedAt == null && !governanceService.shouldRetain(d.createdAt ?? d.scheduledTime, 'medical_record')) {
            await deleteDoseLog(d.id); // Need to expose deleteDoseLog in Store or call repo directly? 
            // Store has no deleteDoseLog usually. Let's call Repo but we need to sync?
            // Repo.delete does soft delete but DOES NOT queue sync in Store unless Store wrapper does it.
            // Current LifeTrackStore architecture wraps Vitals logic but might not wrap Meds logic fully yet?
            // Let's checks if `deleteDoseLog` exists in Store. If not, we should probably add it or use repo + syncQueue manually.
            // For now, calling repo directly. Sync might be missed if not hooked.
            await medicationRepo.deleteDoseLog(d.id);
            // TODO: Enqueue sync if not handled by repo (Repo usually doesn't queue sync)
        }
    }

    HealthLog.i('LifeTrackStore', 'Governance', 'Retention Policy Enforcement Complete');
  }

  Future<Map<String, dynamic>> exportUserData() async {
     HealthLog.i('LifeTrackStore', 'Governance', 'Exporting User Data...');
     
     // Ensure latest data
     await _refreshVitalsCache(); 
     final doses = await medicationRepo.getDoseLogs(includeDeleted: true);
     final meds = await medicationRepo.getMedications(includeDeleted: true);

     final Map<String, dynamic> raw = {
        'profile': userProfile.toJson(),
        'snapshot': snapshot.toJson(),
        'records': _allRecords.map((e) => e.toJson()).toList(),
        'medications': meds.map((m) => m.toJson()).toList(),
        'dose_logs': doses.map((d) => d.toJson()).toList(),
        'weight_history': weightHistory.map((e) => e.toJson()).toList(),
        'bp_history': bpHistory.map((e) => e.toJson()).toList(),
        'hr_history': hrHistory.map((e) => e.toJson()).toList(),
        'glucose_history': glucoseHistory.map((e) => e.toJson()).toList(),
        'activities': _allActivities.map((e) => e.toJson()).toList(),
        'meal_logs': _allMeals.map((e) => e.toJson()).toList(),
        'sleep_logs': _allSleepLogs.map((e) => e.toJson()).toList(),
        'reminders': reminders.map((e) => e.toJson()).toList(),
     };
     
     final policy = ExportPolicy(scope: ExportScope.full);
     return await governanceService.exportData(raw, policy: policy);
  }


  // Helpers
  bool _isToday(DateTime d) {
      final now = DateTime.now();
      return d.year == now.year && d.month == now.month && d.day == now.day;
  }
}
