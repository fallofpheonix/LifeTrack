import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetrack/features/vitals/vitals_provider.dart';
import 'package:lifetrack/core/state/store_provider.dart';
import 'package:lifetrack/data/models/weight_entry.dart';
import 'package:lifetrack/data/models/vitals/blood_pressure_entry.dart';
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

  test('VitalsProvider initializes with empty lists', () {
    final state = container.read(vitalsProvider);
    expect(state.weightHistory, isEmpty);
    expect(state.bpHistory, isEmpty);
    expect(state.hrHistory, isEmpty);
    expect(state.glucoseHistory, isEmpty);
  });

  test('addWeight adds entry to store and updates state', () async {
    final notifier = container.read(vitalsProvider.notifier);
    final entry = WeightEntry(date: DateTime(2023, 1, 1), weightKg: 70.0);

    await notifier.addWeight(entry);

    expect(fakeStore.weightHistory.length, 1);
    expect(fakeStore.weightHistory.first, entry);
    expect(container.read(vitalsProvider).weightHistory.length, 1);
  });

  test('addBloodPressure adds entry to store and updates state', () async {
    final notifier = container.read(vitalsProvider.notifier);
    final entry = BloodPressureEntry(
      id: '1',
      date: DateTime(2023, 1, 1), 
      systolic: 120, 
      diastolic: 80
    );

    await notifier.addBloodPressure(entry);

    expect(fakeStore.bpHistory.length, 1);
    expect(fakeStore.bpHistory.first, entry);
    expect(container.read(vitalsProvider).bpHistory.length, 1);
  });

  test('deleteWeight removes entry from store and updates state', () async {
    final notifier = container.read(vitalsProvider.notifier);
    final date = DateTime(2023, 1, 1);
    final entry = WeightEntry(date: date, weightKg: 70.0);

    await notifier.addWeight(entry);
    expect(container.read(vitalsProvider).weightHistory.length, 1);

    await notifier.deleteWeight(date);

    expect(fakeStore.weightHistory, isEmpty);
    expect(container.read(vitalsProvider).weightHistory, isEmpty);
  });
}
