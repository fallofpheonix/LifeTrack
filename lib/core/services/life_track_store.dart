import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/health_snapshot.dart';
import '../../data/models/activity_log.dart';
import '../../data/models/meal_entry.dart';
import '../../data/models/reminder_item.dart';
import '../../data/models/disease_info.dart';
import '../../data/models/recovery_data_point.dart';
import '../../data/models/health_record_entry.dart';
import '../../data/models/weight_entry.dart';
import '../../data/models/sleep_entry.dart';
import '../../data/models/scientist.dart';
import '../../data/models/news_item.dart';
import '../../data/models/user_profile.dart';
import 'news_service.dart';

const String _snapshotKey = 'lifetrack_snapshot';
const String _remindersKey = 'lifetrack_reminders';
const String _recordsKey = 'lifetrack_records';
const String _sleepKey = 'lifetrack_sleep';
const String _profileKey = 'lifetrack_profile';
const String _mealsKey = 'lifetrack_meals';
const String _activitiesKey = 'lifetrack_activities';
const String _weightKey = 'lifetrack_weight';

class LifeTrackStore extends ChangeNotifier {
  LifeTrackStore({
    required this.snapshot,
    required this.activities,
    required this.meals,
    required this.reminders,
    required this.diseaseGuide,
    required this.records,
    required this.recoveryData,
    required this.userProfile,
    required this.sleepLogs,
    required this.scientists,
    required this.news,
    required this.weightHistory,
  }) {
    _initPedometer();
    _fetchNews();
  }

  HealthSnapshot snapshot;
  final List<ActivityLog> activities;
  final List<MealEntry> meals;
  final List<ReminderItem> reminders;
  final List<DiseaseInfo> diseaseGuide;
  final List<RecoveryDataPoint> recoveryData;
  final List<HealthRecordEntry> records;
  final List<SleepEntry> sleepLogs;
  final List<WeightEntry> weightHistory;
  final List<Scientist> scientists;
  List<NewsItem> news;
  UserProfile userProfile;

  StreamSubscription<StepCount>? _stepCountStream;
  final NewsService _newsService = NewsService();

  Future<void> _fetchNews() async {
    final List<NewsItem> fetched = await _newsService.fetchNews();
    if (fetched.isNotEmpty) {
      news = fetched;
      notifyListeners();
    }
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream.listen(
      (StepCount event) {
        snapshot.steps = event.steps;
        notifyListeners(); // Update UI in real-time
        _persistSnapshot(); 
      },
      onError: (Object error) {
        // Handle error or ignore
        debugPrint('Pedometer error: $error');
      },
    );
  }

  @override
  void dispose() {
    _stepCountStream?.cancel();
    super.dispose();
  }

  static Future<LifeTrackStore> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final HealthSnapshot snapshot = _decodeSnapshot(prefs.getString(_snapshotKey)) ??
        HealthSnapshot(
          steps: 0, // Will be updated by pedometer
          stepsGoal: 10000,
          waterGlasses: 6,
          waterGoal: 8,
          sleepHours: 0, // Calculated from logs
          calories: 1520,
          caloriesGoal: 2100,
        );

    final List<ReminderItem> reminders = _decodeReminders(prefs.getString(_remindersKey)) ??
        <ReminderItem>[
          ReminderItem(title: 'Drink water', timeLabel: 'Every 2 hours', enabled: true),
          ReminderItem(title: 'Take medication', timeLabel: '08:00 PM', enabled: true),
          ReminderItem(title: 'Evening walk', timeLabel: '07:00 PM', enabled: false),
        ];

    final List<HealthRecordEntry> records = _decodeRecords(prefs.getString(_recordsKey)) ??
        <HealthRecordEntry>[
          HealthRecordEntry(
            id: 'seed_1',
            dateLabel: '2026-02-10',
            condition: 'Diabetes (Type 2)',
            vitals: 'Fasting glucose 112 mg/dL',
            note: 'Morning walk completed',
          ),
          HealthRecordEntry(
            id: 'seed_2',
            dateLabel: '2026-02-12',
            condition: 'Hypertension',
            vitals: 'BP 126/82 mmHg',
            note: 'Reduced salty snacks',
          ),
        ];

    final UserProfile userProfile = _decodeProfile(prefs.getString(_profileKey)) ??
        UserProfile(name: 'User', age: 30, weight: 70, height: 170, gender: 'Not specified', bloodType: 'O+');

    final List<SleepEntry> sleepLogs = _decodeSleep(prefs.getString(_sleepKey)) ?? <SleepEntry>[];
    
    // Recalculate sleep hours from logs
    double totalSleep = 0;
    final DateTime now = DateTime.now();
    for (final SleepEntry log in sleepLogs) {
      if (log.endTime.year == now.year && log.endTime.month == now.month && log.endTime.day == now.day) {
        totalSleep += log.durationHours;
      }
    }
    snapshot.sleepHours = totalSleep;

    final List<MealEntry> meals = _decodeMeals(prefs.getString(_mealsKey)) ??
        <MealEntry>[
          MealEntry(id: 'seed_m1', mealType: 'Breakfast', title: 'Oats + Banana', calories: 320),
          MealEntry(id: 'seed_m2', mealType: 'Lunch', title: 'Paneer salad bowl', calories: 460),
          MealEntry(id: 'seed_m3', mealType: 'Snack', title: 'Nuts + Green tea', calories: 180),
          MealEntry(id: 'seed_m4', mealType: 'Dinner', title: 'Dal + Brown rice', calories: 420),
        ];

    final List<ActivityLog> activities = _decodeActivities(prefs.getString(_activitiesKey)) ??
        <ActivityLog>[]; // Empty by default or seeded if needed

    final List<WeightEntry> weightHistory = _decodeWeight(prefs.getString(_weightKey)) ??
        <WeightEntry>[
            WeightEntry(date: DateTime.now().subtract(const Duration(days: 30)), weight: 72.5),
            WeightEntry(date: DateTime.now().subtract(const Duration(days: 14)), weight: 71.8),
            WeightEntry(date: DateTime.now().subtract(const Duration(days: 1)), weight: 71.0),
        ];

    return LifeTrackStore(
      snapshot: snapshot,
      activities: activities,
      meals: meals,
      reminders: reminders,
      weightHistory: weightHistory,
      diseaseGuide: <DiseaseInfo>[
        DiseaseInfo(
          name: 'Diabetes (Type 2)',
          symptoms: 'Frequent urination, fatigue, increased thirst',
          precautions: 'Track glucose, reduce refined sugar, regular exercise',
          prevention: 'Maintain healthy weight, active lifestyle, balanced diet.',
          cure: 'Management via diet, exercise, insulin or oral meds.',
        ),
        DiseaseInfo(
          name: 'Hypertension',
          symptoms: 'Often asymptomatic, headache, dizziness',
          precautions: 'Low-sodium diet, weight control, daily BP monitoring',
          prevention: 'Healthy diet, exercise, limit alcohol and smoking.',
          cure: 'Lifestyle changes, antihypertensive medication.',
        ),
        DiseaseInfo(
          name: 'Hypothyroidism',
          symptoms: 'Weight gain, low energy, dry skin',
          precautions: 'Take medication on time, routine thyroid tests',
          prevention: 'Iodine sufficiency (though some causes are autoimmune).',
          cure: 'Thyroid hormone replacement therapy.',
        ),
        DiseaseInfo(
          name: 'Asthma',
          symptoms: 'Wheezing, shortness of breath, chest tightness, coughing',
          precautions: 'Avoid triggers, inhaler adherence, breathing exercises',
          prevention: 'Avoid allergens, smoke, and pollution.',
          cure: 'No cure, but manageable with inhalers and lifestyle changes.',
        ),
        DiseaseInfo(
          name: 'Arthritis',
          symptoms: 'Joint pain, stiffness, swelling, reduced range of motion',
          precautions: 'Regular low-impact exercise, maintain healthy weight',
          prevention: 'Stay active, protect joints from injury.',
          cure: 'Medication, physiotherapy, sometimes surgery.',
        ),
        DiseaseInfo(
          name: 'Malaria',
          symptoms: 'Fever, chills, headache, nausea, muscle pain',
          precautions: 'Use mosquito nets, insect repellent, antimalarial meds',
          prevention: 'Mosquito control, avoiding bites.',
          cure: 'Prescription antimalarial drugs.',
        ),
        DiseaseInfo(
          name: 'Common Cold',
          symptoms: 'Runny nose, sore throat, cough, congestion',
          precautions: 'Wash hands, avoid close contact with sick people',
          prevention: 'Good hygiene, immune system support.',
          cure: 'Rest, fluids, over-the-counter symptom relief.',
        ),
      ],
      records: records,
      recoveryData: <RecoveryDataPoint>[
        RecoveryDataPoint(month: 'M1', fastingGlucose: 168, postMealGlucose: 238),
        RecoveryDataPoint(month: 'M2', fastingGlucose: 149, postMealGlucose: 212),
        RecoveryDataPoint(month: 'M3', fastingGlucose: 136, postMealGlucose: 194),
        RecoveryDataPoint(month: 'M4', fastingGlucose: 124, postMealGlucose: 176),
      ],
      userProfile: userProfile,
      sleepLogs: sleepLogs,
      scientists: <Scientist>[
        Scientist(
          name: 'Louis Pasteur',
          contribution: 'Germ theory & Pasteurization',
          description: 'French biologist, microbiologist, and chemist renowned for his discoveries of the principles of vaccination, microbial fermentation, and pasteurization.',
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/3/3c/Albert_Edelfelt_-_Louis_Pasteur_-_Google_Art_Project.jpg',
        ),
        Scientist(
          name: 'Marie Curie',
          contribution: 'Radioactivity',
          description: 'Polish and naturalized-French physicist and chemist who conducted pioneering research on radioactivity.',
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7e/Marie_Curie_c1920.jpg',
        ),
        Scientist(
          name: 'Alexander Fleming',
          contribution: 'Penicillin',
          description: 'Scottish physician and microbiologist, best known for discovering the world\'s first broadly effective antibiotic substance.',
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bf/Alexander_Fleming_1943.jpg',
        ),
        Scientist(
          name: 'Edward Jenner',
          contribution: 'Smallpox Vaccine',
          description: 'English physician and scientist who pioneered the concept of vaccines including creating the smallpox vaccine, the world\'s first vaccine.',
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/c2/Edward_Jenner.jpg',
        ),
        Scientist(
          name: 'Florence Nightingale',
          contribution: 'Modern Nursing',
          description: 'English social reformer, statistician and the founder of modern nursing.',
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/14/Florence_Nightingale_%28H_Hering_NPG_x82368%29.jpg',
        ),
      ],
      news: <NewsItem>[],
    );
  }

  Future<void> addWeightEntry(WeightEntry entry) async {
    weightHistory.add(entry);
    weightHistory.sort((WeightEntry a, WeightEntry b) => a.date.compareTo(b.date));
    notifyListeners();
    await _persistWeight();
  }

  Future<void> _persistWeight() async {
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setString(_weightKey, jsonEncode(weightHistory.map((WeightEntry e) => e.toJson()).toList()));
  }

  Future<void> addActivity(ActivityLog activity) async {
    activities.insert(0, activity);
    snapshot.calories = (snapshot.calories - activity.caloriesBurned).clamp(0, 9999);
    notifyListeners();
    await _persistActivities();
    await _persistSnapshot();
  }

  Future<void> deleteActivity(String id) async {
    activities.removeWhere((ActivityLog item) => item.id == id);
    notifyListeners();
    await _persistActivities();
  }

  Future<void> addMeal(MealEntry meal) async {
    meals.insert(0, meal);
    snapshot.calories += meal.calories;
    notifyListeners();
    await _persistMeals();
    await _persistSnapshot();
  }

  Future<void> deleteMeal(String id) async {
    final int index = meals.indexWhere((MealEntry item) => item.id == id);
    if (index != -1) {
      final MealEntry meal = meals[index];
      snapshot.calories = (snapshot.calories - meal.calories).clamp(0, 9999);
      meals.removeAt(index);
      notifyListeners();
      await _persistMeals();
      await _persistSnapshot();
    }
  }

  Future<void> addWaterGlass() async {
    if (snapshot.waterGlasses < 20) {
      snapshot.waterGlasses += 1;
      notifyListeners();
      await _persistSnapshot();
    }
  }

  Future<void> removeWaterGlass() async {
    if (snapshot.waterGlasses > 0) {
      snapshot.waterGlasses -= 1;
      notifyListeners();
      await _persistSnapshot();
    }
  }

  Future<void> toggleReminder(int index, bool enabled) async {
    reminders[index].enabled = enabled;
    notifyListeners();
    await _persistReminders();
  }

  Future<void> addRecord(HealthRecordEntry record) async {
    records.insert(0, record);
    notifyListeners();
    await _persistRecords();
  }

  Future<void> deleteRecord(String id) async {
    records.removeWhere((HealthRecordEntry item) => item.id == id);
    notifyListeners();
    await _persistRecords();
  }

  Future<void> addSleepLog(SleepEntry entry) async {
    sleepLogs.insert(0, entry);
    // Update snapshot if today
    final DateTime now = DateTime.now();
    if (entry.endTime.year == now.year && entry.endTime.month == now.month && entry.endTime.day == now.day) {
       snapshot.sleepHours += entry.durationHours;
    }
    notifyListeners();
    await _persistSleep();
    await _persistSnapshot();
  }

  Future<void> deleteSleepLog(String id) async {
    final int index = sleepLogs.indexWhere((SleepEntry item) => item.id == id);
    if (index != -1) {
       final SleepEntry entry = sleepLogs[index];
       final DateTime now = DateTime.now();
       if (entry.endTime.year == now.year && entry.endTime.month == now.month && entry.endTime.day == now.day) {
         snapshot.sleepHours = (snapshot.sleepHours - entry.durationHours).clamp(0.0, 24.0);
       }
       sleepLogs.removeAt(index);
       notifyListeners();
       await _persistSleep();
       await _persistSnapshot();
    }
  }

  Future<void> updateProfile(UserProfile profile, int newGoal) async {
    userProfile = profile;
    snapshot.caloriesGoal = newGoal; // Sync goal
    notifyListeners();
    await _persistProfile();
    await _persistSnapshot();
  }

  Future<void> _persistSnapshot() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_snapshotKey, jsonEncode(snapshot.toJson()));
  }

  Future<void> _persistReminders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _remindersKey,
      jsonEncode(reminders.map((ReminderItem item) => item.toJson()).toList()),
    );
  }

  Future<void> _persistRecords() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _recordsKey,
      jsonEncode(records.map((HealthRecordEntry item) => item.toJson()).toList()),
    );
  }

  Future<void> _persistMeals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _mealsKey,
      jsonEncode(meals.map((MealEntry item) => item.toJson()).toList()),
    );
  }

  Future<void> _persistActivities() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _activitiesKey,
      jsonEncode(activities.map((ActivityLog item) => item.toJson()).toList()),
    );
  }

  Future<void> _persistSleep() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _sleepKey,
      jsonEncode(sleepLogs.map((SleepEntry item) => item.toJson()).toList()),
    );
  }

  Future<void> _persistProfile() async {
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setString(_profileKey, jsonEncode(userProfile.toJson()));
  }
}

HealthSnapshot? _decodeSnapshot(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  try {
    final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
    return HealthSnapshot.fromJson(json);
  } catch (_) {
    return null;
  }
}

List<ReminderItem>? _decodeReminders(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  try {
    final List<dynamic> json = jsonDecode(raw) as List<dynamic>;
    return json
        .map((dynamic e) => ReminderItem.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return null;
  }
}

List<HealthRecordEntry>? _decodeRecords(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  try {
    final List<dynamic> json = jsonDecode(raw) as List<dynamic>;
    return json
        .map((dynamic e) => HealthRecordEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return null;
  }
}

List<MealEntry>? _decodeMeals(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  try {
    final List<dynamic> json = jsonDecode(raw) as List<dynamic>;
    return json
        .map((dynamic e) => MealEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return null;
  }
}

List<ActivityLog>? _decodeActivities(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  try {
    final List<dynamic> json = jsonDecode(raw) as List<dynamic>;
    return json
        .map((dynamic e) => ActivityLog.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return null;
  }
}

List<SleepEntry>? _decodeSleep(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  try {
    final List<dynamic> json = jsonDecode(raw) as List<dynamic>;
    return json
        .map((dynamic e) => SleepEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return null;
  }
}

UserProfile? _decodeProfile(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  try {
    final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
    return UserProfile.fromJson(json);
  } catch (_) {
    return null;
  }
}

List<WeightEntry>? _decodeWeight(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  try {
    final List<dynamic> json = jsonDecode(raw) as List<dynamic>;
    return json
        .map((dynamic e) => WeightEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return null;
  }
}
