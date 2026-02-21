class NutritionEntry {
  const NutritionEntry({
    required this.id,
    required this.date,
    required this.mealType,
    required this.title,
    required this.calories,
  });

  final String id;
  final DateTime date;
  final String mealType;
  final String title;
  final int calories;

  NutritionEntry copyWith({
    String? id,
    DateTime? date,
    String? mealType,
    String? title,
    int? calories,
  }) {
    return NutritionEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      title: title ?? this.title,
      calories: calories ?? this.calories,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'date': date.toIso8601String(),
      'mealType': mealType,
      'title': title,
      'calories': calories,
    };
  }

  factory NutritionEntry.fromJson(Map<String, dynamic> json) {
    return NutritionEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      mealType: json['mealType'] as String,
      title: json['title'] as String,
      calories: json['calories'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is NutritionEntry &&
        other.id == id &&
        other.date == date &&
        other.mealType == mealType &&
        other.title == title &&
        other.calories == calories;
  }

  @override
  int get hashCode => Object.hash(id, date, mealType, title, calories);
}
