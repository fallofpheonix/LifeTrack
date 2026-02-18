import '../base_health_entry.dart';
import '../enums/data_source.dart';

enum DoseStatus { taken, skipped, missed }

class DoseLog extends BaseHealthEntry {
  DoseLog({
    required this.id,
    required this.medicationId,
    required this.scheduledTime,
    this.takenTime,
    required this.status,
    DataSource source = DataSource.manual,
    DateTime? createdAt,
    DateTime? editedAt,
    DateTime? deletedAt,
    int entityVersion = 1,
  }) : super(
          date: scheduledTime,
          source: source,
          createdAt: createdAt,
          editedAt: editedAt,
          deletedAt: deletedAt,
          entityVersion: entityVersion,
        );

  final String id;
  final String medicationId;
  final DateTime scheduledTime;
  final DateTime? takenTime;
  final DoseStatus status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'medicationId': medicationId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'takenTime': takenTime?.toIso8601String(),
      'status': status.index,
      ...toBaseJson(),
    };
  }

  factory DoseLog.fromJson(Map<String, dynamic> json) {
    return DoseLog(
      id: json['id'] as String,
      medicationId: json['medicationId'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      takenTime: json['takenTime'] != null ? DateTime.parse(json['takenTime'] as String) : null,
      status: DoseStatus.values[json['status'] as int],
      source: DataSource.values.asNameMap()[json['source']] ?? DataSource.manual,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      entityVersion: json['entityVersion'] as int? ?? 1,
    );
  }
}
