import 'package:lifetrack/core/database/repositories/base_repository.dart';
import 'package:lifetrack/domain/models/nutrition_entry.dart';

abstract class NutritionRepository extends BaseRepository<NutritionEntry> {
  Future<List<NutritionEntry>> fetchByDateRange(DateTime start, DateTime end);
}
