class MockHealthRecord {
  final String metric;
  final String value;
  final String trend;
  final String time;
  final DateTime date;

  MockHealthRecord({
    required this.metric,
    required this.value,
    required this.trend,
    required this.time,
    required this.date,
  });

  bool get isUp => trend.toLowerCase() == 'up';

  factory MockHealthRecord.fromJson(Map<String, dynamic> j) {
    return MockHealthRecord(
      metric: j['metric'] as String,
      value: j['value'] as String,
      trend: j['trend'] as String,
      time: j['time'] as String,
      date: DateTime.parse(j['date'] as String),
    );
  }
}
