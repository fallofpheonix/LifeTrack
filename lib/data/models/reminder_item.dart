class ReminderItem {
  ReminderItem({
    required this.title,
    required this.timeLabel,
    required this.enabled,
  });

  final String title;
  final String timeLabel;
  bool enabled;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'timeLabel': timeLabel,
      'enabled': enabled,
    };
  }

  factory ReminderItem.fromJson(Map<String, dynamic> json) {
    return ReminderItem(
      title: json['title'] as String? ?? '',
      timeLabel: json['timeLabel'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
    );
  }
}
