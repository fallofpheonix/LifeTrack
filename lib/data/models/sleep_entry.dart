import 'base_health_entry.dart';
import 'enums/data_source.dart';

class SleepEntry extends BaseHealthEntry {
  SleepEntry({
    required this.id,
    required this.startTime,
    required this.endTime,
    DataSource source = DataSource.manual,
    DateTime? createdAt,
    DateTime? editedAt,
    DateTime? deletedAt,
    int entityVersion = 1,
  }) : super(
          date: startTime,
          source: source,
          createdAt: createdAt,
          editedAt: editedAt,
          deletedAt: deletedAt,
          entityVersion: entityVersion,
        );

  final String id;
  final DateTime startTime;
  final DateTime endTime;

  double get durationHours {
    final Duration diff = endTime.difference(startTime);
    return diff.inMinutes / 60.0;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      ...toBaseJson(),
    };
  }

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
      startTime: DateTime.tryParse(json['startTime'] as String? ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime'] as String? ?? '') ?? DateTime.now(),
      source: DataSource.values.asNameMap()[json['source']] ?? DataSource.manual,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      entityVersion: json['entityVersion'] as int? ?? 1,
    );
  }
}
