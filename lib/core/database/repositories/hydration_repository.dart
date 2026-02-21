import 'package:lifetrack/core/database/repositories/base_repository.dart';
import 'package:lifetrack/domain/models/hydration_entry.dart';
import 'package:lifetrack/shared/models/daily_aggregates.dart';

abstract class HydrationRepository extends BaseRepository<HydrationEntry> {
  Future<List<HydrationEntry>> fetchByDateRange(DateTime start, DateTime end);
  Future<List<HydrationDailyAggregate>> aggregateDaily(DateTime start, DateTime end);
}
