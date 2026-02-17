class WeightEntry {
  WeightEntry({
    required this.date,
    required this.weight,
  });

  final DateTime date;
  final double weight;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'date': date.toIso8601String(),
      'weight': weight,
    };
  }

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
