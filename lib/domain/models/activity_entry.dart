class ActivityEntry {
  const ActivityEntry({
    required this.id,
    required this.date,
    required this.type,
    required this.durationMinutes,
    required this.calories,
  });

  final String id;
  final DateTime date;
  final String type;
  final int durationMinutes;
  final int calories;

  ActivityEntry copyWith({
    String? id,
    DateTime? date,
    String? type,
    int? durationMinutes,
    int? calories,
  }) {
    return ActivityEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      calories: calories ?? this.calories,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'durationMinutes': durationMinutes,
      'calories': calories,
    };
  }

  factory ActivityEntry.fromJson(Map<String, dynamic> json) {
    return ActivityEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      durationMinutes: json['durationMinutes'] as int,
      calories: json['calories'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ActivityEntry &&
        other.id == id &&
        other.date == date &&
        other.type == type &&
        other.durationMinutes == durationMinutes &&
        other.calories == calories;
  }

  @override
  int get hashCode => Object.hash(id, date, type, durationMinutes, calories);
}
