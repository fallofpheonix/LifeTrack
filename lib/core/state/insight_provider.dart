import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/data/models/intelligence/insight.dart';
import 'package:lifetrack/core/services/life_track_store.dart';
import 'package:lifetrack/core/state/store_provider.dart';

final insightProvider =
    StateNotifierProvider<InsightNotifier, List<Insight>>((ref) {
  final store = ref.read(lifeTrackStoreProvider);
  return InsightNotifier(store);
});

class InsightNotifier extends StateNotifier<List<Insight>> {
  final LifeTrackStore store;

  InsightNotifier(this.store) : super(store.insights) {
    store.addListener(_onStoreUpdate);
  }

  void _onStoreUpdate() {
    // In a real app, rely on specific insight updates, or strict equality
    // For now, reload from store
    state = store.insights;
  }

  @override
  void dispose() {
    store.removeListener(_onStoreUpdate);
    super.dispose();
  }
}
