import 'package:drift/drift.dart';
import 'package:lifetrack/core/database/health_database.dart';
import 'package:lifetrack/core/database/repositories/drift_base_repository.dart';
import 'package:lifetrack/core/database/repositories/vitals_repository.dart';
import 'package:lifetrack/domain/models/vital_entry.dart' as domain;
import 'package:lifetrack/shared/models/daily_aggregates.dart';

class DriftVitalsRepository
    extends DriftBaseRepository<domain.VitalEntry, VitalEntries, VitalEntryRecord, VitalEntriesCompanion>
    implements VitalsRepository {
  DriftVitalsRepository(HealthDatabase db) : super(db, db.vitalEntries);

  @override
  domain.VitalEntry toDomain(VitalEntryRecord row) => row.toVitalDomain();

  @override
  VitalEntriesCompanion toCompanion(domain.VitalEntry domain) => domain.toCompanion();

  @override
  Future<List<domain.VitalEntry>> fetchByDateRange(DateTime start, DateTime end) async {
    final rows = await (db.select(db.vitalEntries)
          ..where((tbl) => tbl.timestamp.isBetweenValues(start, end))
          ..orderBy(<OrderingTerm Function(VitalEntries)>[
            (tbl) => OrderingTerm(expression: tbl.timestamp, mode: OrderingMode.asc),
          ]))
        .get();
    return rows.map((row) => toDomain(row)).toList(growable: false);
  }

  @override
  Future<List<VitalDailyAggregate>> aggregateDaily(DateTime start, DateTime end) async {
    final entries = await fetchByDateRange(start, end);
    final Map<DateTime, List<domain.VitalEntry>> grouped = <DateTime, List<domain.VitalEntry>>{};

    for (final domain.VitalEntry e in entries) {
      final DateTime day = DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day);
      grouped.putIfAbsent(day, () => <domain.VitalEntry>[]).add(e);
    }

    final List<VitalDailyAggregate> out = grouped.entries.map((entry) {
      final double avg =
          entry.value.fold<double>(0, (sum, e) => sum + e.value) / entry.value.length;
      return VitalDailyAggregate(day: entry.key, averageValue: avg, count: entry.value.length);
    }).toList(growable: false)
      ..sort((a, b) => a.day.compareTo(b.day));

    return out;
  }
}
