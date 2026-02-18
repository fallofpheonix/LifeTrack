import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/life_track_store.dart';
import '../../data/models/sleep_entry.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/activity_log.dart';
import '../../data/models/activity_type.dart';
import '../../data/models/weight_entry.dart';
import '../dashboard/dashboard_page.dart';
import '../activity/activity_page.dart';
import '../nutrition/nutrition_page.dart';
import '../reminders/reminder_page.dart';
import '../medical/medical_page.dart';
import '../profile/profile_page.dart';
import '../vitals/vitals_page.dart';

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
                    currentGoal: widget.store.snapshot.caloriesGoal,
                    weightHistory: widget.store.weightHistory,
                    onUpdateProfile: (UserProfile p, int goal) => widget.store.updateProfile(p, goal),
                    onAddWeight: (WeightEntry e) => widget.store.addWeightEntry(e),
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
            child: _buildPage(_selectedIndex),
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
            HapticFeedback.selectionClick();
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

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return DashboardPage(
          snapshot: widget.store.snapshot,
          insights: widget.store.insights,
          recoveryData: widget.store.recoveryData,
          news: widget.store.news,
          onAddWater: widget.store.addWaterGlass,
          onRemoveWater: widget.store.removeWaterGlass,
          onLogActivity: _selectActivity,
          onAddSleep: _logSleep,
        );
      case 1:
        return ActivityPage(
          activities: widget.store.activities,
          onLogActivity: _selectActivity,
          onDeleteActivity: widget.store.deleteActivity,
        );
      case 2:
        return NutritionPage(
          meals: widget.store.meals,
          onAddMeal: widget.store.addMeal,
          onDeleteMeal: widget.store.deleteMeal,
        );
      case 3:
        return ReminderPage(
          reminders: widget.store.reminders,
          onToggle: widget.store.toggleReminder,
        );
      case 4:
        return MedicalPage(
          diseaseGuide: widget.store.diseaseGuide,
          records: widget.store.records,
          recoveryData: widget.store.recoveryData,
          scientists: widget.store.scientists,
          news: widget.store.news,
          onAddRecord: widget.store.addRecord,
          onDeleteRecord: widget.store.deleteRecord,
          onOpenVitals: _openVitalsPage,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _selectActivity() async {
    final dynamic result = await showDialog(
      context: context,
      builder: (BuildContext context) => const AddActivityDialog(),
    );
    
    // We need to import ActivityType to use it here or handle mapping.
    // Since we can't easily import ActivityType in this file without adding it to imports, let's assume it's imported.
    // Oh wait, result['type'] is ActivityType. We need to cast it.
    
    if (result != null && result is Map<String, dynamic>) {
       final ActivityType type = result['type'] as ActivityType;
       final DateTime start = result['start'] as DateTime; // Assuming dialog returns start
       final int duration = result['duration'] as int;
       final int calories = result['calories'] as int;

       widget.store.addActivity(
         ActivityLog(
           id: DateTime.now().microsecondsSinceEpoch.toString(),
           date: start,
           durationMinutes: duration,
           type: type,
           name: type.toString().split('.').last, // Use type name as default name
           caloriesBurned: calories,
         ),
       );
    }
  }

  Future<void> _logSleep() async {
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
  }

  void _openVitalsPage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => VitalsPage(
          bpHistory: widget.store.bpHistory,
          hrHistory: widget.store.hrHistory,
          glucoseHistory: widget.store.glucoseHistory,
          onAddBP: widget.store.addBloodPressure,
          onAddHR: widget.store.addHeartRate,
          onAddGlucose: widget.store.addGlucose,
        ),
      ),
    );
  }
}
