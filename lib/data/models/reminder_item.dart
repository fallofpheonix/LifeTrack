class ReminderItem {
  ReminderItem({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.enabled,
    this.days = const [], // Default empty
    this.type = 'general', // Default
  });

  final String id;
  final String title;
  final String timeLabel;
  bool enabled;
  final List<int> days;
  final String type;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'timeLabel': timeLabel,
      'enabled': enabled,
      'days': days,
      'type': type,
    };
  }

  factory ReminderItem.fromJson(Map<String, dynamic> json) {
    return ReminderItem(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? '',
      timeLabel: json['timeLabel'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      days: (json['days'] as List<dynamic>?)?.cast<int>() ?? [],
      type: json['type'] as String? ?? 'general',
    );
  }
}
