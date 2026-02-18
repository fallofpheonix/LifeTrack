import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/domain/education/models/evidence.dart';
import 'package:lifetrack/domain/education/models/quote.dart';
import 'package:lifetrack/domain/education/models/condition.dart';
import 'package:lifetrack/domain/education/models/scientist.dart';
import 'package:lifetrack/domain/education/repositories/education_repository.dart';
import 'package:lifetrack/domain/education/repositories/education_repository_impl.dart';
import 'package:lifetrack/domain/education/services/education_service.dart';

final educationRepositoryProvider =
    Provider<EducationRepository>((ref) => EducationRepositoryImpl());

final educationServiceProvider =
    Provider((ref) => EducationService(ref.read(educationRepositoryProvider)));

final evidenceProvider = FutureProvider.family<Evidence?, String>((ref, metric) {
  return ref.read(educationServiceProvider).getEvidenceForMetric(metric);
});

final quoteProvider = FutureProvider.family<HealthQuote?, String>((ref, metric) {
  return ref.read(educationServiceProvider).getQuote(metric);
});

final conditionProvider = FutureProvider<List<Condition>>((ref) {
  return ref.read(educationServiceProvider).getConditions();
});

final scientistProvider = FutureProvider<List<Scientist>>((ref) {
  return ref.read(educationRepositoryProvider).loadScientists();
});

final allEvidenceProvider = FutureProvider<List<Evidence>>((ref) {
  return ref.read(educationServiceProvider).getAllEvidence();
});
