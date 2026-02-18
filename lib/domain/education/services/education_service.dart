import 'package:lifetrack/domain/education/models/condition.dart';
import 'package:lifetrack/domain/education/models/evidence.dart';
import 'package:lifetrack/domain/education/models/quote.dart';
import 'package:lifetrack/domain/education/repositories/education_repository.dart';

class EducationService {
  final EducationRepository repo;

  EducationService(this.repo);

  Future<Evidence?> getEvidenceForMetric(String metric) async {
    final all = await repo.loadEvidence();
    // Simple logic: return first match or default to first item if available
    try {
      return all.firstWhere(
        (e) => e.relatedMetrics.contains(metric),
        orElse: () => all.first,
      );
    } catch (e) {
      return null;
    }
  }

  Future<HealthQuote?> getQuote(String metric) async {
    final all = await repo.loadQuotes();
    try {
      return all.firstWhere(
        (q) => q.linkedMetric == metric,
        orElse: () => all.first,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<Condition>> getConditions() {
    return repo.loadConditions();
  }

  Future<List<Evidence>> getAllEvidence() {
    return repo.loadEvidence();
  }
}
