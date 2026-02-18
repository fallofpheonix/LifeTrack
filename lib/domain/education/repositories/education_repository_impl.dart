import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lifetrack/domain/education/models/condition.dart';
import 'package:lifetrack/domain/education/models/evidence.dart';
import 'package:lifetrack/domain/education/models/scientist.dart';
import 'package:lifetrack/domain/education/models/quote.dart';
import 'package:lifetrack/domain/education/repositories/education_repository.dart';

class EducationRepositoryImpl implements EducationRepository {
  Future<Map<String, dynamic>> _loadJson(String path) async {
    final raw = await rootBundle.loadString(path);
    return json.decode(raw);
  }

  @override
  Future<List<Condition>> loadConditions() async {
    final data = await _loadJson('assets/medical/conditions_v1.json');
    return (data['conditions'] as List)
        .map((e) => Condition.fromJson(e))
        .toList();
  }

  @override
  Future<List<Evidence>> loadEvidence() async {
    final data = await _loadJson('assets/medical/evidence_v1.json');
    return (data['evidence'] as List)
        .map((e) => Evidence.fromJson(e))
        .toList();
  }

  @override
  Future<List<Scientist>> loadScientists() async {
    final data = await _loadJson('assets/medical/scientists_v1.json');
    return (data['scientists'] as List)
        .map((e) => Scientist.fromJson(e))
        .toList();
  }

  @override
  Future<List<HealthQuote>> loadQuotes() async {
    final data = await _loadJson('assets/medical/quotes_v1.json');
    return (data['quotes'] as List)
        .map((e) => HealthQuote.fromJson(e))
        .toList();
  }
}
