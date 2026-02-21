import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/services/life_track_store.dart';
import 'package:lifetrack/core/state/store_provider.dart';
import 'package:lifetrack/data/models/health_record_entry.dart';

final recordsProvider = StateNotifierProvider<RecordsNotifier, List<HealthRecordEntry>>((ref) {
  final store = ref.read(lifeTrackStoreProvider);
  return RecordsNotifier(store);
});

class RecordsNotifier extends StateNotifier<List<HealthRecordEntry>> {
  final LifeTrackStore store;

  RecordsNotifier(this.store) : super(store.records) {
    store.addListener(_onStoreUpdate);
  }

  void _onStoreUpdate() {
    state = store.records;
  }

  Future<void> addRecord(HealthRecordEntry record) async {
    await store.addHealthRecord(record);
  }

  Future<void> deleteRecord(String id) async {
    await store.deleteRecord(id);
  }

  @override
  void dispose() {
    store.removeListener(_onStoreUpdate);
    super.dispose();
  }
}
