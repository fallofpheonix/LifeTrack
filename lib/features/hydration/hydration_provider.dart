import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/services/life_track_store.dart';
import 'package:lifetrack/core/state/store_provider.dart';

class HydrationState {
  final int current;
  final int goal;

  const HydrationState({required this.current, required this.goal});
  
  // Equality for Riverpod
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HydrationState &&
          runtimeType == other.runtimeType &&
          current == other.current &&
          goal == other.goal;

  @override
  int get hashCode => current.hashCode ^ goal.hashCode;
}


final hydrationProvider =
    StateNotifierProvider<HydrationNotifier, HydrationState>((ref) {
  final store = ref.watch(lifeTrackStoreProvider);
  final notifier = HydrationNotifier(store);
  ref.onDispose(() => notifier.cleanup());
  return notifier;
});

class HydrationNotifier extends StateNotifier<HydrationState> {
  final LifeTrackStore store;

  HydrationNotifier(this.store) : super(_buildState(store)) {
      store.addListener(_onStoreUpdate);
  }

  void _onStoreUpdate() {
      state = _buildState(store);
  }

  void cleanup() {
      store.removeListener(_onStoreUpdate);
  }

  static HydrationState _buildState(LifeTrackStore store) {
    return HydrationState(
      current: store.snapshot.waterGlasses,
      goal: store.snapshot.waterGoal,
    );
  }

  Future<void> addGlass() async {
    await store.addWaterGlass();
    state = _buildState(store);
  }

  Future<void> removeGlass() async {
    await store.removeWaterGlass();
    state = _buildState(store);
  }
}
