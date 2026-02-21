// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_database.dart';

// ignore_for_file: type=lint
class $VitalEntriesTable extends VitalEntries
    with TableInfo<$VitalEntriesTable, VitalEntryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VitalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metricTypeMeta = const VerificationMeta(
    'metricType',
  );
  @override
  late final GeneratedColumn<String> metricType = GeneratedColumn<String>(
    'metric_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    metricType,
    value,
    unit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vital_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VitalEntryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('metric_type')) {
      context.handle(
        _metricTypeMeta,
        metricType.isAcceptableOrUnknown(data['metric_type']!, _metricTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_metricTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VitalEntryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VitalEntryRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      metricType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric_type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
    );
  }

  @override
  $VitalEntriesTable createAlias(String alias) {
    return $VitalEntriesTable(attachedDatabase, alias);
  }
}

class VitalEntryRecord extends DataClass
    implements Insertable<VitalEntryRecord> {
  final String id;
  final DateTime timestamp;
  final String metricType;
  final double value;
  final String unit;
  const VitalEntryRecord({
    required this.id,
    required this.timestamp,
    required this.metricType,
    required this.value,
    required this.unit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['metric_type'] = Variable<String>(metricType);
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    return map;
  }

  VitalEntriesCompanion toCompanion(bool nullToAbsent) {
    return VitalEntriesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      metricType: Value(metricType),
      value: Value(value),
      unit: Value(unit),
    );
  }

  factory VitalEntryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VitalEntryRecord(
      id: serializer.fromJson<String>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      metricType: serializer.fromJson<String>(json['metricType']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'metricType': serializer.toJson<String>(metricType),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
    };
  }

  VitalEntryRecord copyWith({
    String? id,
    DateTime? timestamp,
    String? metricType,
    double? value,
    String? unit,
  }) => VitalEntryRecord(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    metricType: metricType ?? this.metricType,
    value: value ?? this.value,
    unit: unit ?? this.unit,
  );
  VitalEntryRecord copyWithCompanion(VitalEntriesCompanion data) {
    return VitalEntryRecord(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      metricType: data.metricType.present
          ? data.metricType.value
          : this.metricType,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VitalEntryRecord(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('metricType: $metricType, ')
          ..write('value: $value, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, metricType, value, unit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VitalEntryRecord &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.metricType == this.metricType &&
          other.value == this.value &&
          other.unit == this.unit);
}

class VitalEntriesCompanion extends UpdateCompanion<VitalEntryRecord> {
  final Value<String> id;
  final Value<DateTime> timestamp;
  final Value<String> metricType;
  final Value<double> value;
  final Value<String> unit;
  final Value<int> rowid;
  const VitalEntriesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.metricType = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VitalEntriesCompanion.insert({
    required String id,
    required DateTime timestamp,
    required String metricType,
    required double value,
    required String unit,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       timestamp = Value(timestamp),
       metricType = Value(metricType),
       value = Value(value),
       unit = Value(unit);
  static Insertable<VitalEntryRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? metricType,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (metricType != null) 'metric_type': metricType,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VitalEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? timestamp,
    Value<String>? metricType,
    Value<double>? value,
    Value<String>? unit,
    Value<int>? rowid,
  }) {
    return VitalEntriesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      metricType: metricType ?? this.metricType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (metricType.present) {
      map['metric_type'] = Variable<String>(metricType.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VitalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('metricType: $metricType, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityEntriesTable extends ActivityEntries
    with TableInfo<$ActivityEntriesTable, ActivityEntryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    type,
    durationMinutes,
    calories,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityEntryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityEntryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityEntryRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
    );
  }

  @override
  $ActivityEntriesTable createAlias(String alias) {
    return $ActivityEntriesTable(attachedDatabase, alias);
  }
}

class ActivityEntryRecord extends DataClass
    implements Insertable<ActivityEntryRecord> {
  final String id;
  final DateTime date;
  final String type;
  final int durationMinutes;
  final int calories;
  const ActivityEntryRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.durationMinutes,
    required this.calories,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['calories'] = Variable<int>(calories);
    return map;
  }

  ActivityEntriesCompanion toCompanion(bool nullToAbsent) {
    return ActivityEntriesCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      durationMinutes: Value(durationMinutes),
      calories: Value(calories),
    );
  }

  factory ActivityEntryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityEntryRecord(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      calories: serializer.fromJson<int>(json['calories']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'calories': serializer.toJson<int>(calories),
    };
  }

  ActivityEntryRecord copyWith({
    String? id,
    DateTime? date,
    String? type,
    int? durationMinutes,
    int? calories,
  }) => ActivityEntryRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    type: type ?? this.type,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    calories: calories ?? this.calories,
  );
  ActivityEntryRecord copyWithCompanion(ActivityEntriesCompanion data) {
    return ActivityEntryRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      calories: data.calories.present ? data.calories.value : this.calories,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEntryRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('calories: $calories')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, type, durationMinutes, calories);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityEntryRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.durationMinutes == this.durationMinutes &&
          other.calories == this.calories);
}

class ActivityEntriesCompanion extends UpdateCompanion<ActivityEntryRecord> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<int> durationMinutes;
  final Value<int> calories;
  final Value<int> rowid;
  const ActivityEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.calories = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityEntriesCompanion.insert({
    required String id,
    required DateTime date,
    required String type,
    required int durationMinutes,
    required int calories,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       type = Value(type),
       durationMinutes = Value(durationMinutes),
       calories = Value(calories);
  static Insertable<ActivityEntryRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<int>? durationMinutes,
    Expression<int>? calories,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (calories != null) 'calories': calories,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? type,
    Value<int>? durationMinutes,
    Value<int>? calories,
    Value<int>? rowid,
  }) {
    return ActivityEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      calories: calories ?? this.calories,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('calories: $calories, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HydrationEntriesTable extends HydrationEntries
    with TableInfo<$HydrationEntriesTable, HydrationEntryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HydrationEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _glassesMeta = const VerificationMeta(
    'glasses',
  );
  @override
  late final GeneratedColumn<int> glasses = GeneratedColumn<int>(
    'glasses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, glasses];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hydration_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<HydrationEntryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('glasses')) {
      context.handle(
        _glassesMeta,
        glasses.isAcceptableOrUnknown(data['glasses']!, _glassesMeta),
      );
    } else if (isInserting) {
      context.missing(_glassesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HydrationEntryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HydrationEntryRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      glasses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}glasses'],
      )!,
    );
  }

  @override
  $HydrationEntriesTable createAlias(String alias) {
    return $HydrationEntriesTable(attachedDatabase, alias);
  }
}

class HydrationEntryRecord extends DataClass
    implements Insertable<HydrationEntryRecord> {
  final String id;
  final DateTime date;
  final int glasses;
  const HydrationEntryRecord({
    required this.id,
    required this.date,
    required this.glasses,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['glasses'] = Variable<int>(glasses);
    return map;
  }

  HydrationEntriesCompanion toCompanion(bool nullToAbsent) {
    return HydrationEntriesCompanion(
      id: Value(id),
      date: Value(date),
      glasses: Value(glasses),
    );
  }

  factory HydrationEntryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HydrationEntryRecord(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      glasses: serializer.fromJson<int>(json['glasses']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'glasses': serializer.toJson<int>(glasses),
    };
  }

  HydrationEntryRecord copyWith({String? id, DateTime? date, int? glasses}) =>
      HydrationEntryRecord(
        id: id ?? this.id,
        date: date ?? this.date,
        glasses: glasses ?? this.glasses,
      );
  HydrationEntryRecord copyWithCompanion(HydrationEntriesCompanion data) {
    return HydrationEntryRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      glasses: data.glasses.present ? data.glasses.value : this.glasses,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HydrationEntryRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('glasses: $glasses')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, glasses);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HydrationEntryRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.glasses == this.glasses);
}

class HydrationEntriesCompanion extends UpdateCompanion<HydrationEntryRecord> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<int> glasses;
  final Value<int> rowid;
  const HydrationEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.glasses = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HydrationEntriesCompanion.insert({
    required String id,
    required DateTime date,
    required int glasses,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       glasses = Value(glasses);
  static Insertable<HydrationEntryRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<int>? glasses,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (glasses != null) 'glasses': glasses,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HydrationEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<int>? glasses,
    Value<int>? rowid,
  }) {
    return HydrationEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      glasses: glasses ?? this.glasses,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (glasses.present) {
      map['glasses'] = Variable<int>(glasses.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HydrationEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('glasses: $glasses, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NutritionEntriesTable extends NutritionEntries
    with TableInfo<$NutritionEntriesTable, NutritionEntryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutritionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, mealType, title, calories];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrition_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<NutritionEntryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NutritionEntryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutritionEntryRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
    );
  }

  @override
  $NutritionEntriesTable createAlias(String alias) {
    return $NutritionEntriesTable(attachedDatabase, alias);
  }
}

class NutritionEntryRecord extends DataClass
    implements Insertable<NutritionEntryRecord> {
  final String id;
  final DateTime date;
  final String mealType;
  final String title;
  final int calories;
  const NutritionEntryRecord({
    required this.id,
    required this.date,
    required this.mealType,
    required this.title,
    required this.calories,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['meal_type'] = Variable<String>(mealType);
    map['title'] = Variable<String>(title);
    map['calories'] = Variable<int>(calories);
    return map;
  }

  NutritionEntriesCompanion toCompanion(bool nullToAbsent) {
    return NutritionEntriesCompanion(
      id: Value(id),
      date: Value(date),
      mealType: Value(mealType),
      title: Value(title),
      calories: Value(calories),
    );
  }

  factory NutritionEntryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutritionEntryRecord(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      mealType: serializer.fromJson<String>(json['mealType']),
      title: serializer.fromJson<String>(json['title']),
      calories: serializer.fromJson<int>(json['calories']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'mealType': serializer.toJson<String>(mealType),
      'title': serializer.toJson<String>(title),
      'calories': serializer.toJson<int>(calories),
    };
  }

  NutritionEntryRecord copyWith({
    String? id,
    DateTime? date,
    String? mealType,
    String? title,
    int? calories,
  }) => NutritionEntryRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    mealType: mealType ?? this.mealType,
    title: title ?? this.title,
    calories: calories ?? this.calories,
  );
  NutritionEntryRecord copyWithCompanion(NutritionEntriesCompanion data) {
    return NutritionEntryRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      title: data.title.present ? data.title.value : this.title,
      calories: data.calories.present ? data.calories.value : this.calories,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutritionEntryRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mealType: $mealType, ')
          ..write('title: $title, ')
          ..write('calories: $calories')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, mealType, title, calories);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutritionEntryRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.mealType == this.mealType &&
          other.title == this.title &&
          other.calories == this.calories);
}

class NutritionEntriesCompanion extends UpdateCompanion<NutritionEntryRecord> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> mealType;
  final Value<String> title;
  final Value<int> calories;
  final Value<int> rowid;
  const NutritionEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.mealType = const Value.absent(),
    this.title = const Value.absent(),
    this.calories = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NutritionEntriesCompanion.insert({
    required String id,
    required DateTime date,
    required String mealType,
    required String title,
    required int calories,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       mealType = Value(mealType),
       title = Value(title),
       calories = Value(calories);
  static Insertable<NutritionEntryRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? mealType,
    Expression<String>? title,
    Expression<int>? calories,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (mealType != null) 'meal_type': mealType,
      if (title != null) 'title': title,
      if (calories != null) 'calories': calories,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NutritionEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? mealType,
    Value<String>? title,
    Value<int>? calories,
    Value<int>? rowid,
  }) {
    return NutritionEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      title: title ?? this.title,
      calories: calories ?? this.calories,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutritionEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mealType: $mealType, ')
          ..write('title: $title, ')
          ..write('calories: $calories, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$HealthDatabase extends GeneratedDatabase {
  _$HealthDatabase(QueryExecutor e) : super(e);
  $HealthDatabaseManager get managers => $HealthDatabaseManager(this);
  late final $VitalEntriesTable vitalEntries = $VitalEntriesTable(this);
  late final $ActivityEntriesTable activityEntries = $ActivityEntriesTable(
    this,
  );
  late final $HydrationEntriesTable hydrationEntries = $HydrationEntriesTable(
    this,
  );
  late final $NutritionEntriesTable nutritionEntries = $NutritionEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vitalEntries,
    activityEntries,
    hydrationEntries,
    nutritionEntries,
  ];
}

typedef $$VitalEntriesTableCreateCompanionBuilder =
    VitalEntriesCompanion Function({
      required String id,
      required DateTime timestamp,
      required String metricType,
      required double value,
      required String unit,
      Value<int> rowid,
    });
typedef $$VitalEntriesTableUpdateCompanionBuilder =
    VitalEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> timestamp,
      Value<String> metricType,
      Value<double> value,
      Value<String> unit,
      Value<int> rowid,
    });

class $$VitalEntriesTableFilterComposer
    extends Composer<_$HealthDatabase, $VitalEntriesTable> {
  $$VitalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metricType => $composableBuilder(
    column: $table.metricType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VitalEntriesTableOrderingComposer
    extends Composer<_$HealthDatabase, $VitalEntriesTable> {
  $$VitalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metricType => $composableBuilder(
    column: $table.metricType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VitalEntriesTableAnnotationComposer
    extends Composer<_$HealthDatabase, $VitalEntriesTable> {
  $$VitalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get metricType => $composableBuilder(
    column: $table.metricType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);
}

class $$VitalEntriesTableTableManager
    extends
        RootTableManager<
          _$HealthDatabase,
          $VitalEntriesTable,
          VitalEntryRecord,
          $$VitalEntriesTableFilterComposer,
          $$VitalEntriesTableOrderingComposer,
          $$VitalEntriesTableAnnotationComposer,
          $$VitalEntriesTableCreateCompanionBuilder,
          $$VitalEntriesTableUpdateCompanionBuilder,
          (
            VitalEntryRecord,
            BaseReferences<
              _$HealthDatabase,
              $VitalEntriesTable,
              VitalEntryRecord
            >,
          ),
          VitalEntryRecord,
          PrefetchHooks Function()
        > {
  $$VitalEntriesTableTableManager(_$HealthDatabase db, $VitalEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VitalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VitalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VitalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> metricType = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VitalEntriesCompanion(
                id: id,
                timestamp: timestamp,
                metricType: metricType,
                value: value,
                unit: unit,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime timestamp,
                required String metricType,
                required double value,
                required String unit,
                Value<int> rowid = const Value.absent(),
              }) => VitalEntriesCompanion.insert(
                id: id,
                timestamp: timestamp,
                metricType: metricType,
                value: value,
                unit: unit,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VitalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$HealthDatabase,
      $VitalEntriesTable,
      VitalEntryRecord,
      $$VitalEntriesTableFilterComposer,
      $$VitalEntriesTableOrderingComposer,
      $$VitalEntriesTableAnnotationComposer,
      $$VitalEntriesTableCreateCompanionBuilder,
      $$VitalEntriesTableUpdateCompanionBuilder,
      (
        VitalEntryRecord,
        BaseReferences<_$HealthDatabase, $VitalEntriesTable, VitalEntryRecord>,
      ),
      VitalEntryRecord,
      PrefetchHooks Function()
    >;
typedef $$ActivityEntriesTableCreateCompanionBuilder =
    ActivityEntriesCompanion Function({
      required String id,
      required DateTime date,
      required String type,
      required int durationMinutes,
      required int calories,
      Value<int> rowid,
    });
typedef $$ActivityEntriesTableUpdateCompanionBuilder =
    ActivityEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> type,
      Value<int> durationMinutes,
      Value<int> calories,
      Value<int> rowid,
    });

class $$ActivityEntriesTableFilterComposer
    extends Composer<_$HealthDatabase, $ActivityEntriesTable> {
  $$ActivityEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityEntriesTableOrderingComposer
    extends Composer<_$HealthDatabase, $ActivityEntriesTable> {
  $$ActivityEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityEntriesTableAnnotationComposer
    extends Composer<_$HealthDatabase, $ActivityEntriesTable> {
  $$ActivityEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);
}

class $$ActivityEntriesTableTableManager
    extends
        RootTableManager<
          _$HealthDatabase,
          $ActivityEntriesTable,
          ActivityEntryRecord,
          $$ActivityEntriesTableFilterComposer,
          $$ActivityEntriesTableOrderingComposer,
          $$ActivityEntriesTableAnnotationComposer,
          $$ActivityEntriesTableCreateCompanionBuilder,
          $$ActivityEntriesTableUpdateCompanionBuilder,
          (
            ActivityEntryRecord,
            BaseReferences<
              _$HealthDatabase,
              $ActivityEntriesTable,
              ActivityEntryRecord
            >,
          ),
          ActivityEntryRecord,
          PrefetchHooks Function()
        > {
  $$ActivityEntriesTableTableManager(
    _$HealthDatabase db,
    $ActivityEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityEntriesCompanion(
                id: id,
                date: date,
                type: type,
                durationMinutes: durationMinutes,
                calories: calories,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required String type,
                required int durationMinutes,
                required int calories,
                Value<int> rowid = const Value.absent(),
              }) => ActivityEntriesCompanion.insert(
                id: id,
                date: date,
                type: type,
                durationMinutes: durationMinutes,
                calories: calories,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$HealthDatabase,
      $ActivityEntriesTable,
      ActivityEntryRecord,
      $$ActivityEntriesTableFilterComposer,
      $$ActivityEntriesTableOrderingComposer,
      $$ActivityEntriesTableAnnotationComposer,
      $$ActivityEntriesTableCreateCompanionBuilder,
      $$ActivityEntriesTableUpdateCompanionBuilder,
      (
        ActivityEntryRecord,
        BaseReferences<
          _$HealthDatabase,
          $ActivityEntriesTable,
          ActivityEntryRecord
        >,
      ),
      ActivityEntryRecord,
      PrefetchHooks Function()
    >;
typedef $$HydrationEntriesTableCreateCompanionBuilder =
    HydrationEntriesCompanion Function({
      required String id,
      required DateTime date,
      required int glasses,
      Value<int> rowid,
    });
typedef $$HydrationEntriesTableUpdateCompanionBuilder =
    HydrationEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<int> glasses,
      Value<int> rowid,
    });

class $$HydrationEntriesTableFilterComposer
    extends Composer<_$HealthDatabase, $HydrationEntriesTable> {
  $$HydrationEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get glasses => $composableBuilder(
    column: $table.glasses,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HydrationEntriesTableOrderingComposer
    extends Composer<_$HealthDatabase, $HydrationEntriesTable> {
  $$HydrationEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get glasses => $composableBuilder(
    column: $table.glasses,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HydrationEntriesTableAnnotationComposer
    extends Composer<_$HealthDatabase, $HydrationEntriesTable> {
  $$HydrationEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get glasses =>
      $composableBuilder(column: $table.glasses, builder: (column) => column);
}

class $$HydrationEntriesTableTableManager
    extends
        RootTableManager<
          _$HealthDatabase,
          $HydrationEntriesTable,
          HydrationEntryRecord,
          $$HydrationEntriesTableFilterComposer,
          $$HydrationEntriesTableOrderingComposer,
          $$HydrationEntriesTableAnnotationComposer,
          $$HydrationEntriesTableCreateCompanionBuilder,
          $$HydrationEntriesTableUpdateCompanionBuilder,
          (
            HydrationEntryRecord,
            BaseReferences<
              _$HealthDatabase,
              $HydrationEntriesTable,
              HydrationEntryRecord
            >,
          ),
          HydrationEntryRecord,
          PrefetchHooks Function()
        > {
  $$HydrationEntriesTableTableManager(
    _$HealthDatabase db,
    $HydrationEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HydrationEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HydrationEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HydrationEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> glasses = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HydrationEntriesCompanion(
                id: id,
                date: date,
                glasses: glasses,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required int glasses,
                Value<int> rowid = const Value.absent(),
              }) => HydrationEntriesCompanion.insert(
                id: id,
                date: date,
                glasses: glasses,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HydrationEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$HealthDatabase,
      $HydrationEntriesTable,
      HydrationEntryRecord,
      $$HydrationEntriesTableFilterComposer,
      $$HydrationEntriesTableOrderingComposer,
      $$HydrationEntriesTableAnnotationComposer,
      $$HydrationEntriesTableCreateCompanionBuilder,
      $$HydrationEntriesTableUpdateCompanionBuilder,
      (
        HydrationEntryRecord,
        BaseReferences<
          _$HealthDatabase,
          $HydrationEntriesTable,
          HydrationEntryRecord
        >,
      ),
      HydrationEntryRecord,
      PrefetchHooks Function()
    >;
typedef $$NutritionEntriesTableCreateCompanionBuilder =
    NutritionEntriesCompanion Function({
      required String id,
      required DateTime date,
      required String mealType,
      required String title,
      required int calories,
      Value<int> rowid,
    });
typedef $$NutritionEntriesTableUpdateCompanionBuilder =
    NutritionEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> mealType,
      Value<String> title,
      Value<int> calories,
      Value<int> rowid,
    });

class $$NutritionEntriesTableFilterComposer
    extends Composer<_$HealthDatabase, $NutritionEntriesTable> {
  $$NutritionEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NutritionEntriesTableOrderingComposer
    extends Composer<_$HealthDatabase, $NutritionEntriesTable> {
  $$NutritionEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NutritionEntriesTableAnnotationComposer
    extends Composer<_$HealthDatabase, $NutritionEntriesTable> {
  $$NutritionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);
}

class $$NutritionEntriesTableTableManager
    extends
        RootTableManager<
          _$HealthDatabase,
          $NutritionEntriesTable,
          NutritionEntryRecord,
          $$NutritionEntriesTableFilterComposer,
          $$NutritionEntriesTableOrderingComposer,
          $$NutritionEntriesTableAnnotationComposer,
          $$NutritionEntriesTableCreateCompanionBuilder,
          $$NutritionEntriesTableUpdateCompanionBuilder,
          (
            NutritionEntryRecord,
            BaseReferences<
              _$HealthDatabase,
              $NutritionEntriesTable,
              NutritionEntryRecord
            >,
          ),
          NutritionEntryRecord,
          PrefetchHooks Function()
        > {
  $$NutritionEntriesTableTableManager(
    _$HealthDatabase db,
    $NutritionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutritionEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NutritionEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutritionEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NutritionEntriesCompanion(
                id: id,
                date: date,
                mealType: mealType,
                title: title,
                calories: calories,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required String mealType,
                required String title,
                required int calories,
                Value<int> rowid = const Value.absent(),
              }) => NutritionEntriesCompanion.insert(
                id: id,
                date: date,
                mealType: mealType,
                title: title,
                calories: calories,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NutritionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$HealthDatabase,
      $NutritionEntriesTable,
      NutritionEntryRecord,
      $$NutritionEntriesTableFilterComposer,
      $$NutritionEntriesTableOrderingComposer,
      $$NutritionEntriesTableAnnotationComposer,
      $$NutritionEntriesTableCreateCompanionBuilder,
      $$NutritionEntriesTableUpdateCompanionBuilder,
      (
        NutritionEntryRecord,
        BaseReferences<
          _$HealthDatabase,
          $NutritionEntriesTable,
          NutritionEntryRecord
        >,
      ),
      NutritionEntryRecord,
      PrefetchHooks Function()
    >;

class $HealthDatabaseManager {
  final _$HealthDatabase _db;
  $HealthDatabaseManager(this._db);
  $$VitalEntriesTableTableManager get vitalEntries =>
      $$VitalEntriesTableTableManager(_db, _db.vitalEntries);
  $$ActivityEntriesTableTableManager get activityEntries =>
      $$ActivityEntriesTableTableManager(_db, _db.activityEntries);
  $$HydrationEntriesTableTableManager get hydrationEntries =>
      $$HydrationEntriesTableTableManager(_db, _db.hydrationEntries);
  $$NutritionEntriesTableTableManager get nutritionEntries =>
      $$NutritionEntriesTableTableManager(_db, _db.nutritionEntries);
}
