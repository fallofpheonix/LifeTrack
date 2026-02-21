class HydrationEntry {
  const HydrationEntry({
    required this.id,
    required this.date,
    required this.glasses,
  });

  final String id;
  final DateTime date;
  final int glasses;

  HydrationEntry copyWith({
    String? id,
    DateTime? date,
    int? glasses,
  }) {
    return HydrationEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      glasses: glasses ?? this.glasses,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'date': date.toIso8601String(),
      'glasses': glasses,
    };
  }

  factory HydrationEntry.fromJson(Map<String, dynamic> json) {
    return HydrationEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      glasses: json['glasses'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is HydrationEntry &&
        other.id == id &&
        other.date == date &&
        other.glasses == glasses;
  }

  @override
  int get hashCode => Object.hash(id, date, glasses);
}
