import 'package:drift/drift.dart';
import 'package:lifetrack/core/database/health_database.dart';
import 'package:lifetrack/core/database/repositories/base_repository.dart';

abstract class DriftBaseRepository<TDomain, TTable extends Table, TRow extends DataClass,
    TCompanion extends UpdateCompanion<TRow>> extends BaseRepository<TDomain> {
  final TableInfo<TTable, TRow> table;
  final HealthDatabase db;

  DriftBaseRepository(this.db, this.table);

  TDomain toDomain(TRow row);
  TCompanion toCompanion(TDomain domain);

  @override
  Future<List<TDomain>> getAll() async {
    final rows = await db.select(table).get();
    return rows.map(toDomain).toList();
  }

  @override
  Future<TDomain?> getById(String id) async {
    final query = db.select(table)
      ..where((t) => (t as dynamic).id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? toDomain(row) : null;
  }

  @override
  Future<void> upsert(TDomain entry) async {
    await db.into(table).insertOnConflictUpdate(toCompanion(entry));
  }

  @override
  Future<void> delete(String id) async {
    final query = db.delete(table)
      ..where((t) => (t as dynamic).id.equals(id));
    await query.go();
  }

  @override
  Stream<List<TDomain>> watchAll() {
    return db.select(table)
        .watch()
        .map((rows) => rows.map(toDomain).toList());
  }
}
