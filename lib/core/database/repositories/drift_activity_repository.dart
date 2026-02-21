import 'package:drift/drift.dart';
import 'package:lifetrack/core/database/health_database.dart';
import 'package:lifetrack/core/database/repositories/activity_repository.dart';
import 'package:lifetrack/core/database/repositories/drift_base_repository.dart';
import 'package:lifetrack/domain/models/activity_entry.dart' as domain;
import 'package:lifetrack/shared/models/daily_aggregates.dart';

class DriftActivityRepository
    extends DriftBaseRepository<domain.ActivityEntry, ActivityEntries, ActivityEntryRecord, ActivityEntriesCompanion>
    implements ActivityRepository {
  DriftActivityRepository(HealthDatabase db) : super(db, db.activityEntries);

  @override
  domain.ActivityEntry toDomain(ActivityEntryRecord row) => row.toActivityDomain();

  @override
  ActivityEntriesCompanion toCompanion(domain.ActivityEntry domain) => domain.toCompanion();

  @override
  Future<List<domain.ActivityEntry>> fetchByDateRange(DateTime start, DateTime end) async {
    final rows = await (db.select(db.activityEntries)
          ..where((tbl) => tbl.date.isBetweenValues(start, end))
          ..orderBy(<OrderingTerm Function(ActivityEntries)>[
            (tbl) => OrderingTerm(expression: tbl.date, mode: OrderingMode.asc),
          ]))
        .get();
    return rows.map((row) => toDomain(row)).toList(growable: false);
  }

  @override
  Future<List<ActivityDailyAggregate>> aggregateDaily(DateTime start, DateTime end) async {
    final entries = await fetchByDateRange(start, end);
    final Map<DateTime, List<domain.ActivityEntry>> grouped = <DateTime, List<domain.ActivityEntry>>{};

    for (final domain.ActivityEntry e in entries) {
      final DateTime day = DateTime(e.date.year, e.date.month, e.date.day);
      grouped.putIfAbsent(day, () => <domain.ActivityEntry>[]).add(e);
    }

    final List<ActivityDailyAggregate> out = grouped.entries.map((entry) {
      final int totalMinutes = entry.value.fold<int>(0, (sum, e) => sum + e.durationMinutes);
      final int totalCalories = entry.value.fold<int>(0, (sum, e) => sum + e.calories);
      return ActivityDailyAggregate(
        day: entry.key,
        totalMinutes: totalMinutes,
        totalCalories: totalCalories,
      );
    }).toList(growable: false)
      ..sort((a, b) => a.day.compareTo(b.day));

    return out;
  }
}
