import 'package:lifetrack/domain/education/models/condition.dart';
import 'package:lifetrack/domain/education/models/evidence.dart';
import 'package:lifetrack/domain/education/models/disease.dart';
import 'package:lifetrack/domain/education/models/mock_health_record.dart';
import 'package:lifetrack/domain/education/models/pioneer.dart';
import 'package:lifetrack/domain/education/models/research_item.dart';
import 'package:lifetrack/domain/education/models/scientist.dart';
import 'package:lifetrack/domain/education/models/quote.dart';

abstract class EducationRepository {
  Future<List<Condition>> loadConditions();
  Future<List<Evidence>> loadEvidence();
  Future<List<Scientist>> loadScientists();
  Future<List<HealthQuote>> loadQuotes();
  Future<List<Disease>> loadDiseases();
  Future<List<ResearchItem>> loadResearch();
  Future<List<Pioneer>> loadPioneers();
  Future<List<MockHealthRecord>> loadMockRecords();
  Future<List<String>> loadFacts();
}
