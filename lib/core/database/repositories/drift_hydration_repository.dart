import 'package:drift/drift.dart';
import 'package:lifetrack/core/database/health_database.dart';
import 'package:lifetrack/core/database/repositories/drift_base_repository.dart';
import 'package:lifetrack/core/database/repositories/hydration_repository.dart';
import 'package:lifetrack/domain/models/hydration_entry.dart' as domain;
import 'package:lifetrack/shared/models/daily_aggregates.dart';

class DriftHydrationRepository
    extends DriftBaseRepository<domain.HydrationEntry, HydrationEntries, HydrationEntryRecord, HydrationEntriesCompanion>
    implements HydrationRepository {
  DriftHydrationRepository(HealthDatabase db) : super(db, db.hydrationEntries);

  @override
  domain.HydrationEntry toDomain(HydrationEntryRecord row) => row.toHydrationDomain();

  @override
  HydrationEntriesCompanion toCompanion(domain.HydrationEntry domain) => domain.toCompanion();

  @override
  Future<List<domain.HydrationEntry>> fetchByDateRange(DateTime start, DateTime end) async {
    final rows = await (db.select(db.hydrationEntries)
          ..where((tbl) => tbl.date.isBetweenValues(start, end))
          ..orderBy(<OrderingTerm Function(HydrationEntries)>[
            (tbl) => OrderingTerm(expression: tbl.date, mode: OrderingMode.asc),
          ]))
        .get();
    return rows.map((row) => toDomain(row)).toList(growable: false);
  }

  @override
  Future<List<HydrationDailyAggregate>> aggregateDaily(DateTime start, DateTime end) async {
    final entries = await fetchByDateRange(start, end);
    final Map<DateTime, List<domain.HydrationEntry>> grouped = <DateTime, List<domain.HydrationEntry>>{};

    for (final domain.HydrationEntry e in entries) {
      final DateTime day = DateTime(e.date.year, e.date.month, e.date.day);
      grouped.putIfAbsent(day, () => <domain.HydrationEntry>[]).add(e);
    }

    final List<HydrationDailyAggregate> out = grouped.entries.map((entry) {
      final int totalGlasses = entry.value.fold<int>(0, (sum, e) => sum + e.glasses);
      return HydrationDailyAggregate(day: entry.key, totalGlasses: totalGlasses);
    }).toList(growable: false)
      ..sort((a, b) => a.day.compareTo(b.day));

    return out;
  }
}
