import 'package:lifetrack/data/models/enums/data_source.dart';

mixin AuditFieldsMixin {
  DateTime get createdAt;
  DateTime? get editedAt;
  DateTime? get deletedAt;
  int get entityVersion;
  DataSource get source;

  Map<String, dynamic> auditToJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'editedAt': editedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'entityVersion': entityVersion,
      'source': source.toJson(),
    };
  }
}
