import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _snapshotKey = 'lifetrack_snapshot';
const String _remindersKey = 'lifetrack_reminders';
const String _recordsKey = 'lifetrack_records';
const String _sleepKey = 'lifetrack_sleep';
const String _profileKey = 'lifetrack_profile';
const String _mealsKey = 'lifetrack_meals';
const String _activitiesKey = 'lifetrack_activities';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LifeTrackApp());
}

class LifeTrackApp extends StatefulWidget {
  const LifeTrackApp({super.key});

  @override
  State<LifeTrackApp> createState() => _LifeTrackAppState();
}

class _LifeTrackAppState extends State<LifeTrackApp> {
  LifeTrackStore? _store;

  @override
  void initState() {
    super.initState();
    _loadStore();
  }

  Future<void> _loadStore() async {
    final LifeTrackStore store = await LifeTrackStore.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _store = store;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_store == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text('Loading LifeTrack...'),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'LifeTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D8A6F)),
        scaffoldBackgroundColor: const Color(0xFFF3F7F5),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          bodyMedium: TextStyle(fontSize: 14, height: 1.35),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF143A31),
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF143A31),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFD4EFE7),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(fontWeight: FontWeight.w700);
            }
            return const TextStyle(fontWeight: FontWeight.w500);
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFCADBD5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFCADBD5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF1D8A6F), width: 1.4),
          ),
        ),
        useMaterial3: true,
      ),
      home: LifeTrackHomePage(store: _store!),
    );
  }
}

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
  }) {
    _initPedometer();
  }

  HealthSnapshot snapshot;
  final List<ActivityLog> activities;
  final List<MealEntry> meals;
  final List<ReminderItem> reminders;
  final List<DiseaseInfo> diseaseGuide;
  final List<RecoveryDataPoint> recoveryData;
  final List<HealthRecordEntry> records;
  final List<SleepEntry> sleepLogs;
  UserProfile userProfile;

  StreamSubscription<StepCount>? _stepCountStream;

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream.listen(
      (StepCount event) {
        snapshot.steps = event.steps;
        notifyListeners(); // Update UI in real-time
        _persistSnapshot(); // Optional: might be too frequent, maybe debounce?
        // optimizing: only persist if change > 100 or periodically.
        // For now, let's just notify. We will persist on app pause or other events if needed.
        // Or just persist. SharedPrefs is fast enough for occasional writes but 1Hz is too much.
        // Let's not await persist here to avoid blocking.
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
        UserProfile(name: 'User', age: 30, weight: 70, height: 170);

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
        <ActivityLog>[
          ActivityLog(id: 'seed_a1', name: 'Brisk walk', durationMinutes: 35, caloriesBurned: 210),
          ActivityLog(id: 'seed_a2', name: 'Yoga', durationMinutes: 20, caloriesBurned: 90),
          ActivityLog(id: 'seed_a3', name: 'Cycling', durationMinutes: 40, caloriesBurned: 310),
        ];

    return LifeTrackStore(
      snapshot: snapshot,
      activities: activities,
      meals: meals,
      reminders: reminders,
      diseaseGuide: <DiseaseInfo>[
        DiseaseInfo(
          name: 'Diabetes (Type 2)',
          symptoms: 'Frequent urination, fatigue, increased thirst',
          precautions: 'Track glucose, reduce refined sugar, regular exercise',
        ),
        DiseaseInfo(
          name: 'Hypertension',
          symptoms: 'Often asymptomatic, headache, dizziness',
          precautions: 'Low-sodium diet, weight control, daily BP monitoring',
        ),
        DiseaseInfo(
          name: 'Hypothyroidism',
          symptoms: 'Weight gain, low energy, dry skin',
          precautions: 'Take medication on time, routine thyroid tests',
        ),
        DiseaseInfo(
          name: 'Asthma',
          symptoms: 'Shortness of breath, chest tightness, wheezing',
          precautions: 'Avoid triggers, inhaler adherence, breathing exercises',
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
    );
  }

  Future<void> addQuickActivity() async {
    final ActivityLog activity = ActivityLog(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: 'Quick jog',
      durationMinutes: 15,
      caloriesBurned: 120,
    );
    activities.insert(0, activity);
    // snapshot.steps += 1800; // Removed: Pedometer handles steps now
    snapshot.calories = (snapshot.calories - 120).clamp(0, 9999);
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

  Future<void> updateProfile(UserProfile profile) async {
    userProfile = profile;
    notifyListeners();
    await _persistProfile();
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

class LifeTrackHomePage extends StatefulWidget {
  const LifeTrackHomePage({super.key, required this.store});

  final LifeTrackStore store;

  @override
  State<LifeTrackHomePage> createState() => _LifeTrackHomePageState();
}

class _LifeTrackHomePageState extends State<LifeTrackHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.store.addListener(_onStoreUpdated);
  }

  @override
  void didUpdateWidget(covariant LifeTrackHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.store != widget.store) {
      oldWidget.store.removeListener(_onStoreUpdated);
      widget.store.addListener(_onStoreUpdated);
    }
  }

  @override
  void dispose() {
    widget.store.removeListener(_onStoreUpdated);
    super.dispose();
  }

  void _onStoreUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      DashboardPage(
        snapshot: widget.store.snapshot,
        onAddWater: () {
          widget.store.addWaterGlass();
        },
        onQuickLog: () {
          widget.store.addQuickActivity();
        },
        onAddSleep: () async {
          final dynamic result = await showDialog(
            context: context,
            builder: (BuildContext context) => const SleepLogDialog(),
          );
          if (result != null && result is Map<String, dynamic>) {
             widget.store.addSleepLog(
               SleepEntry(
                 id: DateTime.now().microsecondsSinceEpoch.toString(),
                 startTime: result['start'] as DateTime,
                 endTime: result['end'] as DateTime,
               ),
             );
          }
        },
      ),
      ActivityPage(
        activities: widget.store.activities,
        onQuickLog: () {
          widget.store.addQuickActivity();
        },
        onDeleteActivity: (String id) => widget.store.deleteActivity(id),
      ),
      NutritionPage(
        meals: widget.store.meals,
        onAddMeal: (MealEntry meal) => widget.store.addMeal(meal),
        onDeleteMeal: (String id) => widget.store.deleteMeal(id),
      ),
      ReminderPage(
        reminders: widget.store.reminders,
        onToggle: (int index, bool enabled) {
          widget.store.toggleReminder(index, enabled);
        },
      ),
      MedicalPage(
        diseaseGuide: widget.store.diseaseGuide,
        records: widget.store.records,
        recoveryData: widget.store.recoveryData,
        onAddRecord: (HealthRecordEntry entry) {
          widget.store.addRecord(entry);
        },
        onDeleteRecord: (String id) {
          widget.store.deleteRecord(id);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeTrack'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => ProfilePage(
                    userProfile: widget.store.userProfile,
                    onUpdateProfile: (UserProfile p) => widget.store.updateProfile(p),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFE8F4EF), Color(0xFFF5F8F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: KeyedSubtree(
            key: ValueKey<int>(_selectedIndex),
            child: pages[_selectedIndex],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE1ECE8))),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.directions_run), label: 'Activity'),
            NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Nutrition'),
            NavigationDestination(icon: Icon(Icons.notifications_none), label: 'Reminders'),
            NavigationDestination(icon: Icon(Icons.medical_information_outlined), label: 'Medical'),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.snapshot,
    required this.onAddWater,
    required this.onQuickLog,
    required this.onAddSleep,
  });

  final HealthSnapshot snapshot;
  final VoidCallback onAddWater;
  final VoidCallback onQuickLog;
  final VoidCallback onAddSleep;

  @override
  Widget build(BuildContext context) {
    final double hydrationProgress = snapshot.waterGlasses / snapshot.waterGoal;
    final double safeHydrationProgress = hydrationProgress.clamp(0, 1).toDouble();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        AnimatedFadeSlide(
          delay: const Duration(milliseconds: 80),
          child: _HeroCard(snapshot: snapshot),
        ),
        const SizedBox(height: 16),
        AnimatedFadeSlide(
          delay: const Duration(milliseconds: 120),
          child: Text('Daily Highlights', style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            AnimatedFadeSlide(
              delay: const Duration(milliseconds: 160),
              child: MetricCard(
                icon: Icons.directions_walk,
                title: 'Steps',
                value: '${snapshot.steps}/${snapshot.stepsGoal}',
                subtitle: '${(snapshot.steps / snapshot.stepsGoal * 100).round()}% goal',
              ),
            ),
            AnimatedFadeSlide(
              delay: const Duration(milliseconds: 210),
              child: MetricCard(
                icon: Icons.bedtime,
                title: 'Sleep',
                value: '${snapshot.sleepHours.toStringAsFixed(1)} h',
                subtitle: 'Target 8.0 h',
                onTap: onAddSleep,
              ),
            ),
            AnimatedFadeSlide(
              delay: const Duration(milliseconds: 260),
              child: MetricCard(
                icon: Icons.local_fire_department,
                title: 'Calories',
                value: '${snapshot.calories}',
                subtitle: 'Goal ${snapshot.caloriesGoal}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AnimatedFadeSlide(
          delay: const Duration(milliseconds: 300),
          child: Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFD9F2EA),
                child: Icon(Icons.water_drop, color: Color(0xFF1D8A6F)),
              ),
              title: Text('Hydration: ${snapshot.waterGlasses}/${snapshot.waterGoal} glasses'),
              subtitle: const Text('Keep water intake consistent across the day.'),
              trailing: FilledButton(onPressed: onAddWater, child: const Text('+1')),
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedFadeSlide(
          delay: const Duration(milliseconds: 340),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: safeHydrationProgress),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (BuildContext context, double value, Widget? child) {
                return LinearProgressIndicator(
                  minHeight: 8,
                  value: value,
                  backgroundColor: const Color(0xFFD9E7E3),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        AnimatedFadeSlide(
          delay: const Duration(milliseconds: 380),
          child: Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  onPressed: onAddWater,
                  icon: const Icon(Icons.water_drop),
                  label: const Text('Add Water'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onQuickLog,
                  icon: const Icon(Icons.directions_run),
                  label: const Text('Quick Run'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({
    super.key,
    required this.activities,
    required this.onQuickLog,
    required this.onDeleteActivity,
  });

  final List<ActivityLog> activities;
  final VoidCallback onQuickLog;
  final void Function(String id) onDeleteActivity;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text('Movement', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Text('Today\'s Activity', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            FilledButton.icon(
              onPressed: onQuickLog,
              icon: const Icon(Icons.add),
              label: const Text('Quick log'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...activities.asMap().entries.map((MapEntry<int, ActivityLog> entry) {
          final int index = entry.key;
          final ActivityLog activity = entry.value;
          return AnimatedFadeSlide(
            delay: Duration(milliseconds: 120 + (index * 50)),
            child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  const CircleAvatar(child: Icon(Icons.fitness_center)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(activity.name, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text('${activity.durationMinutes} min'),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEE0),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '-${activity.caloriesBurned} kcal',
                      style: const TextStyle(
                        color: Color(0xFFB45A11),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                    onPressed: () => onDeleteActivity(activity.id),
                  ),
                ],
              ),
            ),
            ),
          );
        }),
      ],
    );
  }
}

class NutritionPage extends StatelessWidget {
  const NutritionPage({
    super.key,
    required this.meals,
    required this.onAddMeal,
    required this.onDeleteMeal,
  });

  final List<MealEntry> meals;
  final void Function(MealEntry meal) onAddMeal;
  final void Function(String id) onDeleteMeal;

  @override
  Widget build(BuildContext context) {
    final int totalCalories = meals.fold<int>(0, (int sum, MealEntry item) => sum + item.calories);

    return ListView(
      padding: const EdgeInsets.all(16),
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
                     mealType: 'Snack', // Default or could be selected
                     title: result['title'] as String,
                     calories: result['calories'] as int,
                   );
                   onAddMeal(meal);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Meal'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.restaurant)),
            title: const Text('Daily Nutrition Overview'),
            subtitle: Text('Consumed calories: $totalCalories kcal'),
          ),
        ),
        const SizedBox(height: 12),
        ...meals.asMap().entries.map((MapEntry<int, MealEntry> entry) {
          final int index = entry.key;
          final MealEntry meal = entry.value;
          return AnimatedFadeSlide(
            delay: Duration(milliseconds: 100 + (index * 45)),
            child: Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFDFF2EC),
                child: Icon(_mealIcon(meal.mealType), color: const Color(0xFF1D8A6F)),
              ),
              title: Text('${meal.mealType}: ${meal.title}'),
              subtitle: Text('${meal.calories} kcal'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () => onDeleteMeal(meal.id),
             ),
            ),
            ),
          );
        }),
      ],
    );
  }
}

class ReminderPage extends StatelessWidget {
  const ReminderPage({
    super.key,
    required this.reminders,
    required this.onToggle,
  });

  final List<ReminderItem> reminders;
  final void Function(int index, bool enabled) onToggle;

  @override
  Widget build(BuildContext context) {
    final int activeCount = reminders.where((ReminderItem item) => item.enabled).length;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reminders.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.notifications_active)),
                title: const Text('Reminder Center'),
                subtitle: Text('$activeCount of ${reminders.length} reminders active'),
              ),
            ),
          );
        }
        final int reminderIndex = index - 1;
        final ReminderItem reminder = reminders[reminderIndex];
        return AnimatedFadeSlide(
          delay: Duration(milliseconds: 100 + (reminderIndex * 45)),
          child: Card(
            child: SwitchListTile(
              value: reminder.enabled,
              onChanged: (bool enabled) => onToggle(reminderIndex, enabled),
              title: Text(reminder.title),
              subtitle: Text(reminder.timeLabel),
            ),
          ),
        );
      },
    );
  }
}

class MedicalPage extends StatefulWidget {
  const MedicalPage({
    super.key,
    required this.diseaseGuide,
    required this.records,
    required this.recoveryData,
    required this.onAddRecord,
    required this.onDeleteRecord,
  });

  final List<DiseaseInfo> diseaseGuide;
  final List<HealthRecordEntry> records;
  final List<RecoveryDataPoint> recoveryData;
  final ValueChanged<HealthRecordEntry> onAddRecord;
  final ValueChanged<String> onDeleteRecord;

  @override
  State<MedicalPage> createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showAddRecordDialog() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController conditionController = TextEditingController();
    final TextEditingController vitalsController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    final bool? didSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Health Record'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: conditionController,
                  decoration: const InputDecoration(labelText: 'Condition'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Condition is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: vitalsController,
                  decoration: const InputDecoration(labelText: 'Vitals'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vitals are required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Note'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Note is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final DateTime now = DateTime.now();
                  final String date =
                      '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                  widget.onAddRecord(
                    HealthRecordEntry(
                      id: now.microsecondsSinceEpoch.toString(),
                      dateLabel: date,
                      condition: conditionController.text.trim(),
                      vitals: vitalsController.text.trim(),
                      note: noteController.text.trim(),
                    ),
                  );
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    conditionController.dispose();
    vitalsController.dispose();
    noteController.dispose();

    if (didSave ?? false) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record added')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DiseaseInfo> filteredDiseases = widget.diseaseGuide.where((DiseaseInfo disease) {
      if (_search.isEmpty) {
        return true;
      }
      return disease.name.toLowerCase().contains(_search) ||
          disease.symptoms.toLowerCase().contains(_search) ||
          disease.precautions.toLowerCase().contains(_search);
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text('Medical Hub', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Disease Guide', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                const Text('Educational support only. Not a medical diagnosis.'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    Chip(
                      avatar: const Icon(Icons.menu_book, size: 16),
                      label: Text('${widget.diseaseGuide.length} conditions'),
                    ),
                    Chip(
                      avatar: const Icon(Icons.event_note, size: 16),
                      label: Text('${widget.records.length} records'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  key: const ValueKey<String>('disease_search'),
                  controller: _searchController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search disease, symptoms, precautions',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...filteredDiseases.asMap().entries.map((MapEntry<int, DiseaseInfo> entry) {
          final int index = entry.key;
          final DiseaseInfo disease = entry.value;
          return AnimatedFadeSlide(
            delay: Duration(milliseconds: 90 + (index * 40)),
            child: Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.health_and_safety)),
              title: Text(disease.name),
              subtitle: Text('Symptoms: ${disease.symptoms}\nPrecautions: ${disease.precautions}'),
            ),
            ),
          );
        }),
        if (filteredDiseases.isEmpty)
          const Card(
            child: ListTile(
              title: Text('No matching disease information found.'),
            ),
          ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Text('Health Records', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            FilledButton.icon(
              key: const ValueKey<String>('add_record_button'),
              onPressed: _showAddRecordDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...widget.records.asMap().entries.map((MapEntry<int, HealthRecordEntry> entry) {
          final int index = entry.key;
          final HealthRecordEntry record = entry.value;
          return AnimatedFadeSlide(
            delay: Duration(milliseconds: 110 + (index * 40)),
            child: Dismissible(
            key: ValueKey<String>(record.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Theme.of(context).colorScheme.errorContainer,
              child: const Icon(Icons.delete_outline),
            ),
            onDismissed: (_) {
              widget.onDeleteRecord(record.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Record deleted')),
              );
            },
            child: Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.event_note)),
                title: Text('${record.dateLabel} - ${record.condition}'),
                subtitle: Text('${record.vitals}\n${record.note}'),
              ),
            ),
            ),
          );
        }),
        const SizedBox(height: 10),
        RecoveryTrendCard(data: widget.recoveryData),
      ],
    );
  }
}

class RecoveryTrendCard extends StatelessWidget {
  const RecoveryTrendCard({super.key, required this.data});

  final List<RecoveryDataPoint> data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Health Recovery Trend', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            const Text('Patient glucose trend (mg/dL): lower is better.'),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: CustomPaint(
                painter: RecoveryChartPainter(data: data),
                child: Container(),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 14,
              children: const <Widget>[
                _LegendDot(color: Color(0xFF1D8A6F), label: 'Fasting glucose'),
                _LegendDot(color: Color(0xFFD16F2A), label: 'Post-meal glucose'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class RecoveryChartPainter extends CustomPainter {
  RecoveryChartPainter({required this.data});

  final List<RecoveryDataPoint> data;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) {
      return;
    }

    const double leftPad = 34;
    const double rightPad = 10;
    const double topPad = 10;
    const double bottomPad = 24;

    final double width = size.width - leftPad - rightPad;
    final double height = size.height - topPad - bottomPad;
    if (width <= 0 || height <= 0) {
      return;
    }

    final Paint axisPaint = Paint()
      ..color = const Color(0xFF7E8896)
      ..strokeWidth = 1;
    final Paint gridPaint = Paint()
      ..color = const Color(0xFFE1E6EF)
      ..strokeWidth = 1;

    canvas.drawLine(Offset(leftPad, topPad), Offset(leftPad, topPad + height), axisPaint);
    canvas.drawLine(
      Offset(leftPad, topPad + height),
      Offset(leftPad + width, topPad + height),
      axisPaint,
    );

    final List<int> allValues = <int>[
      ...data.map((RecoveryDataPoint e) => e.fastingGlucose),
      ...data.map((RecoveryDataPoint e) => e.postMealGlucose),
    ];

    final int minValue = allValues.reduce((int a, int b) => a < b ? a : b) - 10;
    final int maxValue = allValues.reduce((int a, int b) => a > b ? a : b) + 10;
    final int span = (maxValue - minValue).clamp(1, 10000);

    for (int i = 0; i < 4; i++) {
      final double y = topPad + (height * i / 3);
      canvas.drawLine(Offset(leftPad, y), Offset(leftPad + width, y), gridPaint);
    }

    final Path fastingPath = Path();
    final Path postMealPath = Path();
    final Paint fastingPaint = Paint()
      ..color = const Color(0xFF1D8A6F)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final Paint postMealPaint = Paint()
      ..color = const Color(0xFFD16F2A)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final int denominator = data.length > 1 ? data.length - 1 : 1;

    for (int i = 0; i < data.length; i++) {
      final RecoveryDataPoint point = data[i];
      final double x = leftPad + (width * i / denominator);
      final double fastingY = topPad + height - ((point.fastingGlucose - minValue) / span) * height;
      final double postMealY = topPad + height - ((point.postMealGlucose - minValue) / span) * height;

      if (i == 0) {
        fastingPath.moveTo(x, fastingY);
        postMealPath.moveTo(x, postMealY);
      } else {
        fastingPath.lineTo(x, fastingY);
        postMealPath.lineTo(x, postMealY);
      }

      canvas.drawCircle(Offset(x, fastingY), 3, fastingPaint..style = PaintingStyle.fill);
      canvas.drawCircle(Offset(x, postMealY), 3, postMealPaint..style = PaintingStyle.fill);
      fastingPaint.style = PaintingStyle.stroke;
      postMealPaint.style = PaintingStyle.stroke;

      final TextPainter monthPainter = TextPainter(
        text: TextSpan(
          text: point.month,
          style: const TextStyle(fontSize: 11, color: Color(0xFF556170)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      monthPainter.paint(canvas, Offset(x - monthPainter.width / 2, topPad + height + 4));
    }

    canvas.drawPath(fastingPath, fastingPaint);
    canvas.drawPath(postMealPath, postMealPaint);
  }

  @override
  bool shouldRepaint(covariant RecoveryChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFDFF2EC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF1D8A6F)),
              ),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 2),
              Text(subtitle),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final HealthSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final int stepsLeft = (snapshot.stepsGoal - snapshot.steps).clamp(0, snapshot.stepsGoal);
    final double progress = (snapshot.steps / snapshot.stepsGoal).clamp(0, 1).toDouble();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF1F8B70), Color(0xFF2AA783)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Welcome back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You are $stepsLeft steps away from your daily goal.',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: <Widget>[
              _HeroPill(
                icon: Icons.directions_walk,
                label: '${snapshot.steps} steps',
              ),
              _HeroPill(
                icon: Icons.water_drop,
                label: '${snapshot.waterGlasses}/${snapshot.waterGoal} glasses',
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeOutCubic,
            builder: (BuildContext context, double value, Widget? child) {
              return LinearProgressIndicator(
                minHeight: 8,
                borderRadius: BorderRadius.circular(100),
                value: value,
                backgroundColor: const Color(0x4DFFFFFF),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AnimatedFadeSlide extends StatefulWidget {
  const AnimatedFadeSlide({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  State<AnimatedFadeSlide> createState() => _AnimatedFadeSlideState();
}

class _AnimatedFadeSlideState extends State<AnimatedFadeSlide> {
  double _target = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _target = 1;
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted) {
          setState(() {
            _target = 1;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _target),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      child: widget.child,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: child,
          ),
        );
      },
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x40FFFFFF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class HealthSnapshot {
  HealthSnapshot({
    required this.steps,
    required this.stepsGoal,
    required this.waterGlasses,
    required this.waterGoal,
    required this.sleepHours,
    required this.calories,
    required this.caloriesGoal,
  });

  int steps;
  final int stepsGoal;
  int waterGlasses;
  final int waterGoal;
  double sleepHours;
  int calories;
  final int caloriesGoal;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'steps': steps,
      'stepsGoal': stepsGoal,
      'waterGlasses': waterGlasses,
      'waterGoal': waterGoal,
      'sleepHours': sleepHours,
      'calories': calories,
      'caloriesGoal': caloriesGoal,
    };
  }

  factory HealthSnapshot.fromJson(Map<String, dynamic> json) {
    return HealthSnapshot(
      steps: json['steps'] as int? ?? 0,
      stepsGoal: json['stepsGoal'] as int? ?? 10000,
      waterGlasses: json['waterGlasses'] as int? ?? 0,
      waterGoal: json['waterGoal'] as int? ?? 8,
      sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? 0,
      calories: json['calories'] as int? ?? 0,
      caloriesGoal: json['caloriesGoal'] as int? ?? 2000,
    );
  }
}

class ActivityLog {
  ActivityLog({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.caloriesBurned,
  });

  final String id;
  final String name;
  final int durationMinutes;
  final int caloriesBurned;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
    };
  }

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: json['name'] as String? ?? 'Activity',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
    );
  }
}

class MealEntry {
  MealEntry({
    required this.id,
    required this.mealType,
    required this.title,
    required this.calories,
  });

  final String id;
  final String mealType;
  final String title;
  final int calories;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'mealType': mealType,
      'title': title,
      'calories': calories,
    };
  }

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
      mealType: json['mealType'] as String? ?? 'Snack',
      title: json['title'] as String? ?? 'Food',
      calories: json['calories'] as int? ?? 0,
    );
  }
}

class SleepEntry {
  SleepEntry({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  final String id;
  final DateTime startTime;
  final DateTime endTime;

  double get durationHours {
    final Duration diff = endTime.difference(startTime);
    return diff.inMinutes / 60.0;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
      startTime: DateTime.tryParse(json['startTime'] as String? ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class UserProfile {
  UserProfile({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
  });

  String name;
  int age;
  double weight;
  double height;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? 'User',
      age: json['age'] as int? ?? 30,
      weight: (json['weight'] as num?)?.toDouble() ?? 70.0,
      height: (json['height'] as num?)?.toDouble() ?? 170.0,
    );
  }
}

class ReminderItem {
  ReminderItem({
    required this.title,
    required this.timeLabel,
    required this.enabled,
  });

  final String title;
  final String timeLabel;
  bool enabled;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'timeLabel': timeLabel,
      'enabled': enabled,
    };
  }

  factory ReminderItem.fromJson(Map<String, dynamic> json) {
    return ReminderItem(
      title: json['title'] as String? ?? '',
      timeLabel: json['timeLabel'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
    );
  }
}

class DiseaseInfo {
  DiseaseInfo({
    required this.name,
    required this.symptoms,
    required this.precautions,
  });

  final String name;
  final String symptoms;
  final String precautions;
}

class HealthRecordEntry {
  HealthRecordEntry({
    required this.id,
    required this.dateLabel,
    required this.condition,
    required this.vitals,
    required this.note,
  });

  final String id;
  final String dateLabel;
  final String condition;
  final String vitals;
  final String note;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'dateLabel': dateLabel,
      'condition': condition,
      'vitals': vitals,
      'note': note,
    };
  }

  factory HealthRecordEntry.fromJson(Map<String, dynamic> json) {
    return HealthRecordEntry(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      dateLabel: json['dateLabel'] as String? ?? '',
      condition: json['condition'] as String? ?? '',
      vitals: json['vitals'] as String? ?? '',
      note: json['note'] as String? ?? '',
    );
  }
}

class RecoveryDataPoint {
  RecoveryDataPoint({
    required this.month,
    required this.fastingGlucose,
    required this.postMealGlucose,
  });

  final String month;
  final int fastingGlucose;
  final int postMealGlucose;
}

IconData _mealIcon(String mealType) {
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userProfile, required this.onUpdateProfile});

  final UserProfile userProfile;
  final ValueChanged<UserProfile> onUpdateProfile;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _ageController = TextEditingController(text: widget.userProfile.age.toString());
    _weightController = TextEditingController(text: widget.userProfile.weight.toString());
    _heightController = TextEditingController(text: widget.userProfile.height.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _save() {
    final UserProfile newProfile = UserProfile(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text) ?? widget.userProfile.age,
      weight: double.tryParse(_weightController.text) ?? widget.userProfile.weight,
      height: double.tryParse(_heightController.text) ?? widget.userProfile.height,
    );
    widget.onUpdateProfile(newProfile);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age', prefixIcon: Icon(Icons.cake_outlined)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Weight (kg)', prefixIcon: Icon(Icons.monitor_weight_outlined)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Height (cm)', prefixIcon: Icon(Icons.height)),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Save Profile'),
          ),
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

class SleepLogDialog extends StatefulWidget {
  const SleepLogDialog({super.key});

  @override
  State<SleepLogDialog> createState() => _SleepLogDialogState();
}

class _SleepLogDialogState extends State<SleepLogDialog> {
  DateTime _start = DateTime.now().subtract(const Duration(hours: 8));
  DateTime _end = DateTime.now();

  Future<void> _pickTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStart ? _start : _end),
    );
    if (picked != null) {
      setState(() {
        final DateTime base = isStart ? _start : _end;
        final DateTime newTime = DateTime(base.year, base.month, base.day, picked.hour, picked.minute);
        if (isStart) {
          _start = newTime;
        } else {
          _end = newTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Duration diff = _end.difference(_start);
    final String duration = '${diff.inHours}h ${diff.inMinutes % 60}m';

    return AlertDialog(
      title: const Text('Log Sleep'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('Bedtime'),
            trailing: Text(TimeOfDay.fromDateTime(_start).format(context)),
            onTap: () => _pickTime(true),
          ),
          ListTile(
            title: const Text('Wake up'),
            trailing: Text(TimeOfDay.fromDateTime(_end).format(context)),
            onTap: () => _pickTime(false),
          ),
          const SizedBox(height: 10),
          Text('Duration: $duration', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, <String, dynamic>{'start': _start, 'end': _end});
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
