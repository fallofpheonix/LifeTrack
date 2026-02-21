import 'package:lifetrack/core/database/repositories/base_repository.dart';
import 'package:lifetrack/domain/models/vital_entry.dart';
import 'package:lifetrack/shared/models/daily_aggregates.dart';

abstract class VitalsRepository extends BaseRepository<VitalEntry> {
  Future<List<VitalEntry>> fetchByDateRange(DateTime start, DateTime end);
  Future<List<VitalDailyAggregate>> aggregateDaily(DateTime start, DateTime end);
}
