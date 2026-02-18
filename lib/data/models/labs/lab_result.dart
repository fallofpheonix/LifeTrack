class LabResult {
  LabResult({
    required this.id,
    required this.testName,
    required this.value,
    required this.unit,
    required this.date,
    this.refRangeLow,
    this.refRangeHigh,
  });

  final String id;
  final String testName;
  final double value;
  final String unit; // Normalized unit (e.g., "mg/dL", "mmol/L")
  final DateTime date;
  final double? refRangeLow;
  final double? refRangeHigh;

  bool get isNormal {
    if (refRangeLow == null || refRangeHigh == null) return true;
    return value >= refRangeLow! && value <= refRangeHigh!;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'testName': testName,
      'value': value,
      'unit': unit,
      'date': date.toIso8601String(),
      'refRangeLow': refRangeLow,
      'refRangeHigh': refRangeHigh,
    };
  }

  factory LabResult.fromJson(Map<String, dynamic> json) {
    return LabResult(
      id: json['id'] as String,
      testName: json['testName'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      date: DateTime.parse(json['date'] as String),
      refRangeLow: (json['refRangeLow'] as num?)?.toDouble(),
      refRangeHigh: (json['refRangeHigh'] as num?)?.toDouble(),
    );
  }
}
