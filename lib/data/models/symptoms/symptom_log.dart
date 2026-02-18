class SymptomLog {
  SymptomLog({
    required this.id,
    required this.symptomName,
    required this.severity, // 1 to 10
    required this.date,
    this.note,
  }) : assert(severity >= 1 && severity <= 10, 'Severity must be between 1 and 10');

  final String id;
  final String symptomName;
  final int severity;
  final DateTime date;
  final String? note;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'symptomName': symptomName,
      'severity': severity,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory SymptomLog.fromJson(Map<String, dynamic> json) {
    return SymptomLog(
      id: json['id'] as String,
      symptomName: json['symptomName'] as String,
      severity: json['severity'] as int,
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
    );
  }
}
