import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/data/models/health_snapshot.dart';
import 'package:lifetrack/core/services/life_track_store.dart';
import 'package:lifetrack/core/state/store_provider.dart';

/// Provides the latest HealthDatasetSnapshot from the store.
/// Rebuilds consumers only when the snapshot changes.
final healthSnapshotProvider =
    StateNotifierProvider<HealthSnapshotNotifier, HealthSnapshot>((ref) {
  final store = ref.read(lifeTrackStoreProvider);
  return HealthSnapshotNotifier(store);
});

class HealthSnapshotNotifier extends StateNotifier<HealthSnapshot> {
  final LifeTrackStore store;

  HealthSnapshotNotifier(this.store) : super(store.snapshot) {
    // Listen to store updates
    store.addListener(_onStoreUpdate);
  }

  void _onStoreUpdate() {
    // Determine if we need to emit a new state
    // For now, we assume any update might change the snapshot.
    // In a real app, strict equality checks would optimize this.
    state = store.snapshot;
  }

  @override
  void dispose() {
    store.removeListener(_onStoreUpdate);
    super.dispose();
  }
}
