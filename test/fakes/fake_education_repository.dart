import 'package:lifetrack/domain/education/models/condition.dart';
import 'package:lifetrack/domain/education/models/disease.dart';
import 'package:lifetrack/domain/education/models/evidence.dart';
import 'package:lifetrack/domain/education/models/mock_health_record.dart';
import 'package:lifetrack/domain/education/models/pioneer.dart';
import 'package:lifetrack/domain/education/models/quote.dart';
import 'package:lifetrack/domain/education/models/research_item.dart';
import 'package:lifetrack/domain/education/models/scientist.dart';
import 'package:lifetrack/domain/education/repositories/education_repository.dart';

class FakeEducationRepository implements EducationRepository {
  @override
  Future<List<Disease>> loadDiseases() async => <Disease>[
        Disease(name: 'Test Disease A', desc: 'd', prevention: 'p', risk: 'r'),
        Disease(name: 'Test Disease B', desc: 'd', prevention: 'p', risk: 'r'),
        Disease(name: 'Test Disease C', desc: 'd', prevention: 'p', risk: 'r'),
        Disease(name: 'Test Disease D', desc: 'd', prevention: 'p', risk: 'r'),
        Disease(name: 'Test Disease E', desc: 'd', prevention: 'p', risk: 'r'),
      ];

  @override
  Future<List<ResearchItem>> loadResearch() async => <ResearchItem>[
        ResearchItem(title: 'Mock Research', source: 'Test', impact: 'Impact'),
      ];

  @override
  Future<List<MockHealthRecord>> loadMockRecords() async => <MockHealthRecord>[
        MockHealthRecord(
          metric: 'BP',
          value: '120/80',
          trend: 'up',
          time: '2h ago',
          date: DateTime(2026, 1, 1),
        ),
      ];

  @override
  Future<List<Pioneer>> loadPioneers() async => <Pioneer>[
        Pioneer(
          name: 'Mock Scientist',
          contribution: 'Discovery',
          relevance: 'Relevance',
          image: 'alexander_fleming.jpg',
        ),
      ];

  @override
  Future<List<String>> loadFacts() async => <String>['Mock Fact'];

  @override
  Future<List<Condition>> loadConditions() async => <Condition>[];

  @override
  Future<List<Evidence>> loadEvidence() async => <Evidence>[];

  @override
  Future<List<Scientist>> loadScientists() async => <Scientist>[];

  @override
  Future<List<HealthQuote>> loadQuotes() async => <HealthQuote>[];
}
