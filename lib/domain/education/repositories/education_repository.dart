import 'package:lifetrack/domain/education/models/condition.dart';
import 'package:lifetrack/domain/education/models/evidence.dart';
import 'package:lifetrack/domain/education/models/scientist.dart';
import 'package:lifetrack/domain/education/models/quote.dart';

abstract class EducationRepository {
  Future<List<Condition>> loadConditions();
  Future<List<Evidence>> loadEvidence();
  Future<List<Scientist>> loadScientists();
  Future<List<HealthQuote>> loadQuotes();
}
