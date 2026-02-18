import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/services/life_track_store.dart';
import 'package:lifetrack/core/state/store_provider.dart';
import 'package:lifetrack/data/models/vitals/blood_pressure_entry.dart';
import 'package:lifetrack/data/models/vitals/heart_rate_entry.dart';
import 'package:lifetrack/data/models/vitals/glucose_entry.dart';
import 'package:lifetrack/data/models/weight_entry.dart';

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

  factory VitalsState.fromStore(LifeTrackStore store) {
    return VitalsState(
      weightHistory: store.weightHistory,
      bpHistory: store.bpHistory,
      hrHistory: store.hrHistory,
      glucoseHistory: store.glucoseHistory,
    );
  }

  bool get isEmpty => 
    weightHistory.isEmpty && bpHistory.isEmpty && hrHistory.isEmpty && glucoseHistory.isEmpty;
}

final vitalsProvider = StateNotifierProvider<VitalsNotifier, VitalsState>((ref) {
  final store = ref.watch(lifeTrackStoreProvider);
  return VitalsNotifier(store);
});

class VitalsNotifier extends StateNotifier<VitalsState> {
  final LifeTrackStore store;

  VitalsNotifier(this.store) : super(VitalsState.fromStore(store)) {
    store.addListener(_onStoreUpdate);
  }

  void _onStoreUpdate() {
    state = VitalsState.fromStore(store);
  }

  // Forwarding methods can be added here as needed, or handled via Store access in controllers if complex
  Future<void> addWeight(WeightEntry entry) async => store.addWeightEntry(entry);
  Future<void> addBP(BloodPressureEntry entry) async => store.addBloodPressure(entry);
  Future<void> addHeartRate(HeartRateEntry entry) async => store.addHeartRate(entry);
  Future<void> addGlucose(GlucoseEntry entry) async => store.addGlucose(entry);

  @override
  void dispose() {
    store.removeListener(_onStoreUpdate);
    super.dispose();
  }
}
