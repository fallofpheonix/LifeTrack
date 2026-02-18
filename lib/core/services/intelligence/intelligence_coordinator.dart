import '../../../data/models/intelligence/insight.dart';
import '../../../data/models/base_health_entry.dart';
import '../../../data/models/sleep_entry.dart';
import '../../../data/models/weight_entry.dart';
import 'consistency_service.dart';
import 'plateau_service.dart';
import 'suggestion_service.dart';

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
    List<SleepEntry>? sleepEntries,
    List<WeightEntry>? weightEntries,
  }) async {
    final insights = <Insight>[];

    // 1. Consistency
    final consistencyScore = _consistencyService.calculateConsistencyScore(allEntries);
    
    // 2. Suggestions (includes Consistency insights)
    insights.addAll(_suggestionService.generateSuggestions(
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
