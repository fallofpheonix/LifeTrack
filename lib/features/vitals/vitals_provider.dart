import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/data/models/weight_entry.dart';
import 'package:lifetrack/data/models/vitals/blood_pressure_entry.dart';
import 'package:lifetrack/data/models/vitals/heart_rate_entry.dart';
import 'package:lifetrack/data/models/vitals/glucose_entry.dart';
import 'package:lifetrack/core/services/life_track_store.dart';
import 'package:lifetrack/core/state/store_provider.dart';

class VitalsState {
  final List<WeightEntry> weightHistory;
  final List<BloodPressureEntry> bpHistory;
  final List<HeartRateEntry> hrHistory;
  final List<GlucoseEntry> glucoseHistory;

  const VitalsState({
    this.weightHistory = const [],
    this.bpHistory = const [],
    this.hrHistory = const [],
    this.glucoseHistory = const [],
  });
  
  // Equality for Riverpod
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VitalsState &&
          runtimeType == other.runtimeType &&
          weightHistory == other.weightHistory &&
          bpHistory == other.bpHistory &&
          hrHistory == other.hrHistory &&
          glucoseHistory == other.glucoseHistory;

  @override
  int get hashCode => 
      weightHistory.hashCode ^ 
      bpHistory.hashCode ^ 
      hrHistory.hashCode ^ 
      glucoseHistory.hashCode;
}

final vitalsProvider =
    StateNotifierProvider<VitalsNotifier, VitalsState>((ref) {
  final store = ref.watch(lifeTrackStoreProvider);
  final notifier = VitalsNotifier(store);
  ref.onDispose(() => notifier.cleanup());
  return notifier;
});

class VitalsNotifier extends StateNotifier<VitalsState> {
  final LifeTrackStore store;

  VitalsNotifier(this.store) : super(_buildState(store)) {
      // Listen to store updates to refresh vitals
      store.addListener(_onStoreUpdate);
  }

  static VitalsState _buildState(LifeTrackStore store) {
    return VitalsState(
      weightHistory: store.weightHistory,
      bpHistory: store.bpHistory,
      hrHistory: store.hrHistory,
      glucoseHistory: store.glucoseHistory,
    );
  }

  void _onStoreUpdate() {
      state = _buildState(store);
  }

  void cleanup() {
    store.removeListener(_onStoreUpdate);
  }

  // Actions
  Future<void> addWeight(WeightEntry entry) async {
    await store.addWeightEntry(entry);
    // State updates via listener
  }

  Future<void> addBloodPressure(BloodPressureEntry entry) async {
    await store.addBloodPressure(entry);
  }

  Future<void> addHeartRate(HeartRateEntry entry) async {
    await store.addHeartRate(entry);
  }
  
  Future<void> addGlucose(GlucoseEntry entry) async {
    await store.addGlucose(entry);
  }
  
  // Deletions
  Future<void> deleteWeight(DateTime date) async {
      await store.deleteWeight(date);
  }
  
  Future<void> deleteBloodPressure(String id) async {
      await store.deleteBP(id);
  }
  
  Future<void> deleteHeartRate(String id) async {
      await store.deleteHeartRate(id);
  }
  
  Future<void> deleteGlucose(String id) async {
      await store.deleteGlucose(id);
  }
}
