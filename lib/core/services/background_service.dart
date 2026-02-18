import 'dart:convert';

import 'package:lifetrack/data/models/health_snapshot.dart';
import 'package:lifetrack/data/models/reminder_item.dart';
import 'package:lifetrack/data/models/health_record_entry.dart';
import 'package:lifetrack/data/models/user_profile.dart';
import 'package:lifetrack/data/models/sleep_entry.dart';
import 'package:lifetrack/data/models/meal_entry.dart';
import 'package:lifetrack/data/models/activity_log.dart';
import 'package:lifetrack/data/models/vitals/blood_pressure_entry.dart';
import 'package:lifetrack/data/models/vitals/heart_rate_entry.dart';
import 'package:lifetrack/data/models/vitals/glucose_entry.dart';
import 'package:lifetrack/data/models/weight_entry.dart';

/// Service responsible for offloading heavy tasks to background isolates.
/// Currently runs on main thread for Phase 5, will be moved to isolates in Phase 5B.
class BackgroundService {
  
  static Future<HealthSnapshot?> decodeSnapshot(String? jsonStr) async {
    if (jsonStr == null) return null;
    try {
      return HealthSnapshot.fromJson(jsonDecode(jsonStr));
    } catch (_) {
      return null;
    }
  }

  static Future<List<ReminderItem>> decodeReminders(String? jsonStr) async {
    if (jsonStr == null) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => ReminderItem.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<HealthRecordEntry>> decodeRecords(String? jsonStr) async {
    if (jsonStr == null) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => HealthRecordEntry.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<UserProfile?> decodeProfile(String? jsonStr) async {
    if (jsonStr == null) return null;
    try {
      return UserProfile.fromJson(jsonDecode(jsonStr));
    } catch (_) {
      return null;
    }
  }

  static Future<List<SleepEntry>> decodeSleep(String? jsonStr) async {
    if (jsonStr == null) return [];
    try {
       final List<dynamic> list = jsonDecode(jsonStr);
       return list.map((e) => SleepEntry.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<MealEntry>> decodeMeals(String? jsonStr) async {
    if (jsonStr == null) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => MealEntry.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<ActivityLog>> decodeActivities(String? jsonStr) async {
    if (jsonStr == null) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => ActivityLog.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<BloodPressureEntry>> decodeBP(String? jsonStr) async {
    if (jsonStr == null) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => BloodPressureEntry.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<HeartRateEntry>> decodeHR(String? jsonStr) async {
    if (jsonStr == null) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => HeartRateEntry.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<GlucoseEntry>> decodeGlucose(String? jsonStr) async {
    if (jsonStr == null) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => GlucoseEntry.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<WeightEntry>> decodeWeight(String? jsonStr) async {
    if (jsonStr == null) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => WeightEntry.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
