class Evidence {
  final String id;
  final List<String> relatedMetrics;
  final String statement;
  final String sourceType;
  final int year;
  final double confidence;

  Evidence({
    required this.id,
    required this.relatedMetrics,
    required this.statement,
    required this.sourceType,
    required this.year,
    required this.confidence,
  });

  factory Evidence.fromJson(Map<String, dynamic> json) {
    return Evidence(
      id: json['id'],
      relatedMetrics: List<String>.from(json['relatedMetrics']),
      statement: json['statement'],
      sourceType: json['sourceType'] ?? 'unknown',
      year: json['year'],
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}
