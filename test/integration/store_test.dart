import 'package:flutter_test/flutter_test.dart';
import 'package:lifetrack/core/services/life_track_store.dart';
import 'package:lifetrack/core/services/data_governance_service.dart';
import 'package:lifetrack/core/services/secure_serializer.dart';
import 'package:lifetrack/core/services/sync_queue_service.dart';
import 'package:lifetrack/core/services/sync_service.dart';
import 'package:lifetrack/core/services/user_session_service.dart';
import 'package:lifetrack/data/repositories/local_vitals_repository.dart';
import 'package:lifetrack/core/data/repository/medication_repository.dart';
import 'package:lifetrack/data/models/health_snapshot.dart';
import 'package:lifetrack/data/models/user_profile.dart';
import 'package:lifetrack/data/models/weight_entry.dart';
import 'package:lifetrack/data/models/sync/sync_operation.dart'; 
import 'package:lifetrack/data/models/medication/medication.dart';
import 'package:lifetrack/data/models/medication/dose_log.dart';

import 'package:lifetrack/core/services/intelligence/consistency_service.dart';
import 'package:lifetrack/core/services/intelligence/plateau_service.dart';
import 'package:lifetrack/core/services/intelligence/suggestion_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fakes using flutter_test's Fake
class FakeSecureSerializer extends Fake implements SecureSerializer {
  @override
  Future<String> encryptString(String value) async => value; 
  @override
  Future<String> decryptString(String value) async => value;
}

class FakeSyncQueueService extends Fake implements SyncQueueService {
    @override
    Future<void> enqueue(SyncOperation op) async {}
}

class FakeSyncService extends Fake implements SyncService {
    // Need to supply constructor if extending concrete class, but implementing implicit interface should be fine for Fake
    @override
    Future<void> triggerSync() async {}
}

class FakeMedicationRepository extends Fake implements MedicationRepository {
    @override
    Future<List<DoseLog>> getDoseLogs({DateTime? start, DateTime? end, bool includeDeleted = false}) async => [];
    @override
    Future<List<Medication>> getMedications({bool includeDeleted = false}) async => [];
    
    // Stub logging just in case init calls it? No, init calls getWeight etc from vitalRepo
}

class FakeUserSessionService extends Fake implements UserSessionService {}

void main() {
  late LifeTrackStore store;
  late SharedPreferences prefs;
  late LocalVitalsRepository vitalsRepo;
  
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // 1. Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    
    // 2. Setup Real Repos backed by Mock Prefs
    vitalsRepo = LocalVitalsRepository(prefs);
    
    // 3. Setup Dependencies
    final secureSerializer = FakeSecureSerializer();
    final syncQueue = FakeSyncQueueService();
    final syncService = FakeSyncService();
    final medicationRepo = FakeMedicationRepository();
    final sessionService = FakeUserSessionService();
    final governanceService = DataGovernanceService();
    
    // 4. Init Store
    store = LifeTrackStore(
      vitalsRepo: vitalsRepo,
      medicationRepo: medicationRepo,
      sessionService: sessionService,
      secureSerializer: secureSerializer,
      syncQueue: syncQueue,
      syncService: syncService,
      governanceService: governanceService,
      consistencyService: ConsistencyService(),
      plateauService: PlateauService(),
      suggestionService: SuggestionService(),
      snapshot: HealthSnapshot.empty(),
      userProfile: UserProfile.empty(),
    );
  });

  test('LifeTrackStore persists weight entry to Repository', () async {
    final date = DateTime(2025, 1, 1);
    final entry = WeightEntry(date: date, weightKg: 75.0);

    // Action
    await store.addWeightEntry(entry);
    
    // Verify State
    expect(store.weightHistory.length, 1);
    expect(store.weightHistory.first.weightKg, 75.0);

    // Verify Repo/Persistence
    final fromRepo = await vitalsRepo.getWeight();
    expect(fromRepo.length, 1);
    expect(fromRepo.first.weightKg, 75.0);
  });
  
  test('LifeTrackStore deletes weight entry via Governance/Delete', () async {
    final date = DateTime(2025, 1, 1);
    final entry = WeightEntry(date: date, weightKg: 75.0);

    await store.addWeightEntry(entry);
    expect(store.weightHistory.length, 1);
    
    // Action
    await store.deleteWeight(date);
    
    // Verify State
    expect(store.weightHistory, isEmpty);
    
    // Verify Repo
    final fromRepo = await vitalsRepo.getWeight();
    expect(fromRepo, isEmpty);
  });
}
