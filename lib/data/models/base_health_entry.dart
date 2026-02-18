import 'package:lifetrack/data/models/enums/data_source.dart';
import 'package:lifetrack/data/models/mixins/audit_fields_mixin.dart';

abstract class BaseHealthEntry with AuditFieldsMixin {
  BaseHealthEntry({
    required this.date,
    this.source = DataSource.manual,
    DateTime? createdAt,
    this.editedAt,
    this.deletedAt,
    this.entityVersion = 1,
  }) : createdAt = createdAt ?? date;

  final DateTime date;
  
  @override
  final DataSource source;
  
  @override
  final DateTime createdAt;
  
  @override
  final DateTime? editedAt;
  
  @override
  final DateTime? deletedAt;
  
  @override
  final int entityVersion;

  bool get isDeleted => deletedAt != null;

  Map<String, dynamic> toBaseJson() {
    return {
      'date': date.toIso8601String(),
      ...auditToJson(),
    };
  }
}
