import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetrack/core/state/health_snapshot_provider.dart';
import 'package:lifetrack/core/state/store_provider.dart';
import '../../helpers/fake_life_track_store.dart';

void main() {
  late FakeLifeTrackStore fakeStore;
  late ProviderContainer container;

  setUp(() {
    fakeStore = FakeLifeTrackStore();
    container = ProviderContainer(
      overrides: [
        lifeTrackStoreProvider.overrideWithValue(fakeStore),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('HealthSnapshotProvider initializes with empty snapshot', () {
    final snapshot = container.read(healthSnapshotProvider);
    expect(snapshot.steps, 0);
    expect(snapshot.waterGlasses, 0);
  });

  test('HealthSnapshotProvider updates when store changes', () async {
    // Initial read to set up listener
    final snapshot1 = container.read(healthSnapshotProvider);
    expect(snapshot1.waterGlasses, 0);

    // Update store directly
    await fakeStore.addWaterGlass();

    // Provider should emit new value
    final snapshot2 = container.read(healthSnapshotProvider);
    expect(snapshot2.waterGlasses, 1);
  });
}
