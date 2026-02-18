import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/services/life_track_store.dart';

/// Exposes the LifeTrackStore singleton to the Riverpod tree.
/// This allows other providers to access the store without direct static calls.
final lifeTrackStoreProvider = Provider<LifeTrackStore>((ref) {
  throw UnimplementedError('lifeTrackStoreProvider must be overridden in main.dart');
});
