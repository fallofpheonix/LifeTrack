import 'package:flutter/foundation.dart';
import 'package:lifetrack/core/services/life_track_store.dart';
import 'package:lifetrack/data/models/health_snapshot.dart';
import 'package:lifetrack/data/models/user_profile.dart';
import 'package:lifetrack/data/models/weight_entry.dart';
import 'package:lifetrack/data/models/vitals/blood_pressure_entry.dart';
import 'package:lifetrack/data/models/vitals/heart_rate_entry.dart';
import 'package:lifetrack/data/models/vitals/glucose_entry.dart';

class FakeLifeTrackStore extends ChangeNotifier implements LifeTrackStore {
  @override
  HealthSnapshot snapshot = HealthSnapshot.empty();

  @override
  UserProfile userProfile = UserProfile.empty();

  @override
  List<WeightEntry> weightHistory = [];

  @override
  List<BloodPressureEntry> bpHistory = [];

  @override
  List<HeartRateEntry> hrHistory = [];

  @override
  List<GlucoseEntry> glucoseHistory = [];
  
  // -- Methods --

  @override
  Future<void> addWaterGlass() async {
    snapshot = snapshot.copyWith(waterGlasses: snapshot.waterGlasses + 1);
    notifyListeners();
  }

  @override
  Future<void> removeWaterGlass() async {
    if (snapshot.waterGlasses > 0) {
      snapshot = snapshot.copyWith(waterGlasses: snapshot.waterGlasses - 1);
      notifyListeners();
    }
  }

  @override
  Future<void> addWeightEntry(WeightEntry entry) async {
    weightHistory.add(entry);
    notifyListeners();
  }

  @override
  Future<void> addBloodPressure(BloodPressureEntry entry) async {
    bpHistory.add(entry);
    notifyListeners();
  }

  @override
  Future<void> addHeartRate(HeartRateEntry entry) async {
    hrHistory.add(entry);
    notifyListeners();
  }

  @override
  Future<void> addGlucose(GlucoseEntry entry) async {
    glucoseHistory.add(entry);
    notifyListeners();
  }

  @override
  Future<void> deleteWeight(DateTime date) async {
    weightHistory.removeWhere((e) => e.date == date);
    notifyListeners();
  }
  
  @override
  Future<void> deleteBP(String id) async {
    bpHistory.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  @override
  Future<void> deleteHeartRate(String id) async {
    hrHistory.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  @override
  Future<void> deleteGlucose(String id) async {
    glucoseHistory.removeWhere((e) => e.id == id);
    notifyListeners();
  }
  
  // Stubs for other methods to satisfy interface
  @override
  dynamic noSuchMethod(Invocation invocation) {
    // This allows us to only implement what we need for specific tests
    // largely avoiding boilerplate for unused methods in unit tests.
    // However, for strict typing in tests, it's better to implement or mock.
    // For this Fake, we implement state-mutating methods used by Providers.
    return super.noSuchMethod(invocation);
  }
}
