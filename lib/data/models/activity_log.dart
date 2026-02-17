import 'activity_type.dart';

class ActivityLog {
  ActivityLog({
    required this.id,
    required this.type,
    required this.name,
    required this.durationMinutes,
    required this.caloriesBurned,
  });

  final String id;
  final ActivityType type;
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
    };
  }

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
      type: ActivityType.values[(json['type'] as int?) ?? ActivityType.other.index],
      name: json['name'] as String? ?? 'Activity',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
    );
  }
}
