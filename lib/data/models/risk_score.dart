class RiskScore {
  RiskScore({
    required this.id,
    required this.date,
    required this.score,
    required this.breakdown,
  });

  final String id;
  final DateTime date;
  final int score; // 0-100 (Higher is riskier)
  final Map<String, int> breakdown; // e.g., {'bmi': 10, 'bp': 20}

  String get riskLevel {
    if (score < 20) return 'Low';
    if (score < 50) return 'Moderate';
    return 'High';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'date': date.toIso8601String(),
      'score': score,
      'breakdown': breakdown,
    };
  }

  factory RiskScore.fromJson(Map<String, dynamic> json) {
    return RiskScore(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      score: json['score'] as int,
      breakdown: Map<String, int>.from(json['breakdown'] as Map<dynamic, dynamic>),
    );
  }
}
