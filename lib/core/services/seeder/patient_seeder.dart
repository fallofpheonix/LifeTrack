import 'dart:math';

import 'package:lifetrack/core/services/life_track_store.dart';
import 'package:lifetrack/data/models/activity_log.dart';
import 'package:lifetrack/data/models/activity_type.dart';
import 'package:lifetrack/data/models/vitals/blood_pressure_entry.dart';
import 'package:lifetrack/data/models/vitals/heart_rate_entry.dart';
import 'package:lifetrack/data/models/weight_entry.dart';

/// Service to seed the database with synthetic patient data for stress testing.
class PatientSeeder {
  final LifeTrackStore _store;
  final Random _random = Random();

  PatientSeeder(this._store);

  /// Generates 50-100 records for Vitals and Activities.
  Future<void> seedData() async {
    // Generate between 50 and 100 records
    final int count = 50 + _random.nextInt(51); 
    final DateTime now = DateTime.now();

    // 1. Weight History (Decreasing trend generally)
    for (int i = 0; i < count; i++) {
      final DateTime date = now.subtract(Duration(days: i * 2)); // Every 2 days
      // Base weight 80kg, fluctuating, but trending down slightly
      final double weight = 80.0 - (i * 0.05) + (_random.nextDouble() * 2 - 1);
      final entry = WeightEntry(
        date: date.toUtc(),
        weightKg: double.parse(weight.toStringAsFixed(1)),
      );
      // We use the store's method which persists and updates cache
      await _store.addWeightEntry(entry);
    }

    // 2. Blood Pressure (Random normal range)
    for (int i = 0; i < count; i++) {
        final DateTime date = now.subtract(Duration(days: i));
        // Sys: 110-130, Dia: 70-85
        final int sys = 110 + _random.nextInt(21);
        final int dia = 70 + _random.nextInt(16);
        final entry = BloodPressureEntry(
            id: 'seed_bp_$i',
            date: date.toUtc(),
            systolic: sys,
            diastolic: dia,
            createdAt: date.toUtc(),
        );
        await _store.addBloodPressure(entry);
    }

    // 3. Heart Rate (Varied)
     for (int i = 0; i < count; i++) {
        final DateTime date = now.subtract(Duration(hours: i * 12)); // Twice a day
        final int hr = 60 + _random.nextInt(40); // 60-100
        final entry = HeartRateEntry(
            id: 'seed_hr_$i',
            date: date.toUtc(),
            bpm: hr,
            createdAt: date.toUtc(),
        );
        await _store.addHeartRate(entry);
    }

    // 4. Activities
    final List<ActivityType> activities = <ActivityType>[
      ActivityType.run,
      ActivityType.walk,
      ActivityType.swim,
      ActivityType.cycle,
      ActivityType.yoga,
    ];
    for (int i = 0; i < count; i++) {
         final DateTime date = now.subtract(Duration(days: i));
         final ActivityType activity = activities[_random.nextInt(activities.length)];
         final int duration = 15 + _random.nextInt(46); // 15-60 mins
         final log = ActivityLog(
             id: 'seed_act_$i',
             date: date.toUtc(),
             type: activity,
             name: activity.displayName,
             durationMinutes: duration,
             caloriesBurned: duration * activity.caloriesPerMinute + _random.nextInt(25),
             createdAt: date.toUtc(),
         );
         await _store.addActivity(log);
    }
  }
}
