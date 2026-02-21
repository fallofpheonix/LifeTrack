class VitalEntry {
  const VitalEntry({
    required this.id,
    required this.timestamp,
    required this.metricType,
    required this.value,
    required this.unit,
  });

  final String id;
  final DateTime timestamp;
  final String metricType;
  final double value;
  final String unit;

  VitalEntry copyWith({
    String? id,
    DateTime? timestamp,
    String? metricType,
    double? value,
    String? unit,
  }) {
    return VitalEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      metricType: metricType ?? this.metricType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'metricType': metricType,
      'value': value,
      'unit': unit,
    };
  }

  factory VitalEntry.fromJson(Map<String, dynamic> json) {
    return VitalEntry(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metricType: json['metricType'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is VitalEntry &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.metricType == metricType &&
        other.value == value &&
        other.unit == unit;
  }

  @override
  int get hashCode => Object.hash(id, timestamp, metricType, value, unit);
}
