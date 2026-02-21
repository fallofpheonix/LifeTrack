import 'package:drift/drift.dart';
import 'package:lifetrack/core/database/health_database.dart';
import 'package:lifetrack/core/database/repositories/drift_base_repository.dart';
import 'package:lifetrack/core/database/repositories/nutrition_repository.dart';
import 'package:lifetrack/domain/models/nutrition_entry.dart' as domain;

class DriftNutritionRepository
    extends DriftBaseRepository<domain.NutritionEntry, NutritionEntries, NutritionEntryRecord, NutritionEntriesCompanion>
    implements NutritionRepository {
  DriftNutritionRepository(HealthDatabase db) : super(db, db.nutritionEntries);

  @override
  domain.NutritionEntry toDomain(NutritionEntryRecord row) => row.toNutritionDomain();

  @override
  NutritionEntriesCompanion toCompanion(domain.NutritionEntry domain) => domain.toCompanion();

  @override
  Future<List<domain.NutritionEntry>> fetchByDateRange(DateTime start, DateTime end) async {
    final rows = await (db.select(db.nutritionEntries)
          ..where((tbl) => tbl.date.isBetweenValues(start, end))
          ..orderBy(<OrderingTerm Function(NutritionEntries)>[
            (tbl) => OrderingTerm(expression: tbl.date, mode: OrderingMode.asc),
          ]))
        .get();
    return rows.map((row) => toDomain(row)).toList(growable: false);
  }
}
