import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetrack/features/hydration/hydration_provider.dart';
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

  test('HydrationProvider initializes with 0 glasses', () {
    final state = container.read(hydrationProvider);
    expect(state.current, 0);
  });

  test('addGlass increments water count in store and state', () async {
    final notifier = container.read(hydrationProvider.notifier);
    
    await notifier.addGlass();
    
    expect(fakeStore.snapshot.waterGlasses, 1);
    expect(container.read(hydrationProvider).current, 1);
  });

  test('removeGlass decrements water count', () async {
    // Valid way: use notifier to add first
    final notifier = container.read(hydrationProvider.notifier);
    await notifier.addGlass(); // 1
    await notifier.addGlass(); // 2
    
    expect(container.read(hydrationProvider).current, 2);

    await notifier.removeGlass();
    expect(container.read(hydrationProvider).current, 1);
    expect(fakeStore.snapshot.waterGlasses, 1);
  });

  test('removeGlass does not go below zero', () async {
    final notifier = container.read(hydrationProvider.notifier);
    
    expect(container.read(hydrationProvider).current, 0);
    
    await notifier.removeGlass();
    
    expect(container.read(hydrationProvider).current, 0);
    expect(fakeStore.snapshot.waterGlasses, 0);
  });
}
