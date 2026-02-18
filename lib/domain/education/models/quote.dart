class HealthQuote {
  final String text;
  final String linkedMetric;

  HealthQuote({
    required this.text,
    required this.linkedMetric,
  });

  factory HealthQuote.fromJson(Map<String, dynamic> json) {
    return HealthQuote(
      text: json['text'],
      linkedMetric: json['linkedMetric'],
    );
  }
}
