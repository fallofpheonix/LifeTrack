import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import 'package:lifetrack/domain/models/activity_entry.dart' as domain;
import 'package:lifetrack/domain/models/hydration_entry.dart' as domain;
import 'package:lifetrack/domain/models/nutrition_entry.dart' as domain;
import 'package:lifetrack/domain/models/vital_entry.dart' as domain;

part 'health_database.g.dart';

@DataClassName('VitalEntryRecord')
class VitalEntries extends Table {
  @override
  String get tableName => 'vital_entries';

  TextColumn get id => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get metricType => text()();
  RealColumn get value => real()();
  TextColumn get unit => text()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DataClassName('ActivityEntryRecord')
class ActivityEntries extends Table {
  @override
  String get tableName => 'activity_entries';

  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()();
  IntColumn get durationMinutes => integer()();
  IntColumn get calories => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DataClassName('HydrationEntryRecord')
class HydrationEntries extends Table {
  @override
  String get tableName => 'hydration_entries';

  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get glasses => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DataClassName('NutritionEntryRecord')
class NutritionEntries extends Table {
  @override
  String get tableName => 'nutrition_entries';

  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get mealType => text()();
  TextColumn get title => text()();
  IntColumn get calories => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DriftDatabase(
  tables: <Type>[VitalEntries, ActivityEntries, HydrationEntries, NutritionEntries],
  daos: <Type>[],
)
class HealthDatabase extends _$HealthDatabase {
  HealthDatabase({QueryExecutor? executor}) : super(executor ?? _defaultExecutor());

  @override
  int get schemaVersion => 2;
}

LazyDatabase _defaultExecutor() {
  return LazyDatabase(() async {
    final Directory dbDir = Directory(p.join(Directory.current.path, '.dart_tool', 'lifetrack_db'));
    if (!dbDir.existsSync()) {
      dbDir.createSync(recursive: true);
    }
    final File file = File(p.join(dbDir.path, 'health.sqlite'));
    return NativeDatabase(file);
  });
}

extension VitalEntryDriftMapper on domain.VitalEntry {
  VitalEntriesCompanion toCompanion() {
    return VitalEntriesCompanion.insert(
      id: id,
      timestamp: timestamp,
      metricType: metricType,
      value: value,
      unit: unit,
    );
  }
}

extension VitalRowDomainMapper on VitalEntryRecord {
  domain.VitalEntry toVitalDomain() {
    return domain.VitalEntry(
      id: id,
      timestamp: timestamp,
      metricType: metricType,
      value: value,
      unit: unit,
    );
  }
}

extension ActivityEntryDriftMapper on domain.ActivityEntry {
  ActivityEntriesCompanion toCompanion() {
    return ActivityEntriesCompanion.insert(
      id: id,
      date: date,
      type: type,
      durationMinutes: durationMinutes,
      calories: calories,
    );
  }
}

extension ActivityRowDomainMapper on ActivityEntryRecord {
  domain.ActivityEntry toActivityDomain() {
    return domain.ActivityEntry(
      id: id,
      date: date,
      type: type,
      durationMinutes: durationMinutes,
      calories: calories,
    );
  }
}

extension HydrationEntryDriftMapper on domain.HydrationEntry {
  HydrationEntriesCompanion toCompanion() {
    return HydrationEntriesCompanion.insert(
      id: id,
      date: date,
      glasses: glasses,
    );
  }
}

extension HydrationRowDomainMapper on HydrationEntryRecord {
  domain.HydrationEntry toHydrationDomain() {
    return domain.HydrationEntry(
      id: id,
      date: date,
      glasses: glasses,
    );
  }
}

extension NutritionEntryDriftMapper on domain.NutritionEntry {
  NutritionEntriesCompanion toCompanion() {
    return NutritionEntriesCompanion.insert(
      id: id,
      date: date,
      mealType: mealType,
      title: title,
      calories: calories,
    );
  }
}

extension NutritionRowDomainMapper on NutritionEntryRecord {
  domain.NutritionEntry toNutritionDomain() {
    return domain.NutritionEntry(
      id: id,
      date: date,
      mealType: mealType,
      title: title,
      calories: calories,
    );
  }
}
