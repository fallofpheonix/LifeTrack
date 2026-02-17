class SleepEntry {
  SleepEntry({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

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
    };
  }

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
      startTime: DateTime.tryParse(json['startTime'] as String? ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
