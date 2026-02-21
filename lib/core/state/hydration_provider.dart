import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/services/life_track_store.dart';
import 'package:lifetrack/core/state/store_provider.dart';

class HydrationState {
  final int current;
  final int goal;

  const HydrationState({required this.current, required this.goal});

  factory HydrationState.fromStore(LifeTrackStore store) {
    return HydrationState(
      current: store.snapshot.waterGlasses,
      goal: store.snapshot.waterGoal,
    );
  }
}

final hydrationProvider = StateNotifierProvider<HydrationNotifier, HydrationState>((ref) {
  final store = ref.read(lifeTrackStoreProvider);
  return HydrationNotifier(store);
});

class HydrationNotifier extends StateNotifier<HydrationState> {
  final LifeTrackStore store;

  HydrationNotifier(this.store) : super(HydrationState.fromStore(store)) {
    store.addListener(_onStoreUpdate);
  }

  void _onStoreUpdate() {
    state = HydrationState.fromStore(store);
  }

  Future<void> addGlass() async {
    await store.addWaterGlass();
    // State update happens via listener
  }

  Future<void> removeGlass() async {
    await store.removeWaterGlass();
    // State update happens via listener
  }

  @override
  void dispose() {
    store.removeListener(_onStoreUpdate);
    super.dispose();
  }
}
