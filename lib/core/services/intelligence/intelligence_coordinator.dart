import 'package:lifetrack/data/models/intelligence/insight.dart';
import 'package:lifetrack/data/models/base_health_entry.dart';
import 'package:lifetrack/data/models/sleep_entry.dart';
import 'package:lifetrack/data/models/weight_entry.dart';
import 'package:lifetrack/data/models/health_snapshot.dart'; // Added
import 'package:lifetrack/data/models/user_profile.dart';   // Added
import 'package:lifetrack/core/services/intelligence/consistency_service.dart';
import 'package:lifetrack/core/services/intelligence/plateau_service.dart';
import 'package:lifetrack/core/services/intelligence/suggestion_service.dart';

class IntelligenceCoordinator {
  final ConsistencyService _consistencyService;
  final PlateauService _plateauService;
  final SuggestionService _suggestionService;

  IntelligenceCoordinator({
    ConsistencyService? consistencyService,
    PlateauService? plateauService,
    SuggestionService? suggestionService,
  })  : _consistencyService = consistencyService ?? ConsistencyService(),
        _plateauService = plateauService ?? PlateauService(),
        _suggestionService = suggestionService ?? SuggestionService();

  Future<List<Insight>> runAnalysis({
    required List<BaseHealthEntry> allEntries,
    required HealthSnapshot snapshot,
    required UserProfile profile,
    List<SleepEntry>? sleepEntries,
    List<WeightEntry>? weightEntries,
  }) async {
    final insights = <Insight>[];

    // 1. Consistency
    // 1. Consistency
    final allDates = allEntries.map((e) => e.date).toList();
    final consistencyScore = _consistencyService.calculateConsistencyScore(allDates);
    
    // 2. Suggestions (includes Consistency insights)
    // 2. Suggestions (includes Consistency insights)
    insights.addAll(_suggestionService.generateSuggestions(
      snapshot,
      profile,
      sleepEntries: sleepEntries,
      consistencyScore: consistencyScore,
    ));

    // 3. Plateaus
    if (weightEntries != null && weightEntries.isNotEmpty) {
      final isPlateau = _plateauService.detectWeightPlateau(weightEntries);
      if (isPlateau) {
        insights.add(Insight(
          id: 'weight_plateau',
          title: 'Weight Stable',
          message: 'Your weight has been stable for the last 14 days.',
          type: InsightType.info,
          date: DateTime.now(),
          confidence: 'Medium',
        ));
      }
    }

    return insights;
  }
}
