import 'package:lifetrack/core/database/repositories/base_repository.dart';
import 'package:lifetrack/domain/models/activity_entry.dart';
import 'package:lifetrack/shared/models/daily_aggregates.dart';

abstract class ActivityRepository extends BaseRepository<ActivityEntry> {
  Future<List<ActivityEntry>> fetchByDateRange(DateTime start, DateTime end);
  Future<List<ActivityDailyAggregate>> aggregateDaily(DateTime start, DateTime end);
}
