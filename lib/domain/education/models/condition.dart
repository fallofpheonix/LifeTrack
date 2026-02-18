class Condition {
  final String id;
  final String name;
  final String category;
  final String summary;
  final List<String> symptoms;
  final List<String> prevention;
  final List<String> management;

  Condition({
    required this.id,
    required this.name,
    required this.category,
    required this.summary,
    required this.symptoms,
    required this.prevention,
    required this.management,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      summary: json['summary'],
      symptoms: List<String>.from(json['symptoms']),
      prevention: List<String>.from(json['prevention']),
      management: List<String>.from(json['management']),
    );
  }
}
