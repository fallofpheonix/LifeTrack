import 'package:lifetrack/data/models/base_health_entry.dart';
import 'package:lifetrack/data/models/enums/data_source.dart';
import 'package:lifetrack/data/models/activity_type.dart';

class ActivityLog extends BaseHealthEntry {
  ActivityLog({
    required this.id,
    required this.type,
    required this.name,
    required this.durationMinutes,
    required this.caloriesBurned,
    required super.date,
    super.source,
    super.createdAt,
    super.editedAt,
    super.deletedAt,
    super.entityVersion,
  });

  final String id;
  final ActivityType type;
  ActivityType get activityType => type; // Compatibility alias
  final String name;
  final int durationMinutes;
  final int caloriesBurned;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type.index,
      'name': name,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      ...toBaseJson(),
    };
  }

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
      type: ActivityType.values[(json['type'] as int?) ?? ActivityType.other.index],
      name: json['name'] as String? ?? 'Activity',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
      source: DataSource.values.asNameMap()[json['source']] ?? DataSource.manual,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      entityVersion: json['entityVersion'] as int? ?? 1,
    );
  }
}
