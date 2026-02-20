import 'dart:math';

import 'package:lifetrack/domain/education/models/condition.dart';
import 'package:lifetrack/domain/education/models/disease.dart';
import 'package:lifetrack/domain/education/models/evidence.dart';
import 'package:lifetrack/domain/education/models/research_item.dart';
import 'package:lifetrack/domain/education/models/quote.dart';
import 'package:lifetrack/domain/education/repositories/education_repository.dart';

class EducationService {
  final EducationRepository repo;
  final Random _rng;
  String? _sessionFact;

  EducationService(this.repo, {Random? random}) : _rng = random ?? Random();

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

  Future<List<Disease>> getRotatingDiseases({int count = 5}) async {
    final List<Disease> all = await repo.loadDiseases();
    all.shuffle(_rng);
    return all.take(count.clamp(1, all.length)).toList(growable: false);
  }

  Future<List<ResearchItem>> getDailyResearch({int count = 3}) async {
    final List<ResearchItem> all = await repo.loadResearch();
    all.shuffle(_rng);
    return all.take(count.clamp(1, all.length)).toList(growable: false);
  }

  Future<String> getSessionFact() async {
    if (_sessionFact != null) {
      return _sessionFact!;
    }
    final List<String> facts = await repo.loadFacts();
    facts.shuffle(_rng);
    _sessionFact = facts.first;
    return _sessionFact!;
  }
}
