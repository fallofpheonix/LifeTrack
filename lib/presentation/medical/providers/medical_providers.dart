import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/domain/education/models/disease.dart';
import 'package:lifetrack/domain/education/models/mock_health_record.dart';
import 'package:lifetrack/domain/education/models/pioneer.dart';
import 'package:lifetrack/domain/education/models/research_item.dart';
import 'package:lifetrack/domain/education/repositories/education_repository.dart';
import 'package:lifetrack/domain/education/repositories/education_repository_impl.dart';
import 'package:lifetrack/domain/education/services/education_service.dart';

final educationRepositoryProvider = Provider<EducationRepository>(
  (ref) => EducationRepositoryImpl(),
);

final educationServiceProvider = Provider<EducationService>(
  (ref) => EducationService(ref.read(educationRepositoryProvider)),
);

final personalLogProvider = FutureProvider.autoDispose<List<MockHealthRecord>>(
  (ref) => ref.read(educationRepositoryProvider).loadMockRecords(),
);

final rotatingDiseaseProvider = FutureProvider.autoDispose<List<Disease>>(
  (ref) => ref.read(educationServiceProvider).getRotatingDiseases(),
);

final insightsFeedProvider = FutureProvider.autoDispose<List<ResearchItem>>(
  (ref) => ref.read(educationServiceProvider).getDailyResearch(),
);

final pioneersProvider = FutureProvider.autoDispose<List<Pioneer>>(
  (ref) => ref.read(educationRepositoryProvider).loadPioneers(),
);

final didYouKnowProvider = FutureProvider<String>(
  (ref) => ref.read(educationServiceProvider).getSessionFact(),
);
