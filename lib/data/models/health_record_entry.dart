class HealthRecordEntry {
  HealthRecordEntry({
    required this.id,
    required this.dateLabel,
    required this.condition,
    required this.vitals,
    required this.note,
  });

  final String id;
  final String dateLabel;
  final String condition;
  final String vitals;
  final String note;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'dateLabel': dateLabel,
      'condition': condition,
      'vitals': vitals,
      'note': note,
    };
  }

  factory HealthRecordEntry.fromJson(Map<String, dynamic> json) {
    return HealthRecordEntry(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      dateLabel: json['dateLabel'] as String? ?? '',
      condition: json['condition'] as String? ?? '',
      vitals: json['vitals'] as String? ?? '',
      note: json['note'] as String? ?? '',
    );
  }
}
