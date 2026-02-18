enum InsightType { warning, success, info, critical, alert }

class Insight {
  final String id;
  final String title;
  final String message;
  final InsightType type;
  final DateTime date;
  final String? actionLabel;
  final String? confidence; // e.g. "High", "Medium" based on data quantity

  Insight({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    this.actionLabel,
    this.confidence,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'date': date.toIso8601String(),
      'actionLabel': actionLabel,
      'confidence': confidence,
    };
  }

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: InsightType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => InsightType.info,
      ),
      date: DateTime.parse(json['date'] as String),
      actionLabel: json['actionLabel'] as String?,
      confidence: json['confidence'] as String?,
    );
  }
}
