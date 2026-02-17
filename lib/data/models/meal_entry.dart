class MealEntry {
  MealEntry({
    required this.id,
    required this.mealType,
    required this.title,
    required this.calories,
  });

  final String id;
  final String mealType;
  final String title;
  final int calories;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'mealType': mealType,
      'title': title,
      'calories': calories,
    };
  }

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
      mealType: json['mealType'] as String? ?? 'Snack',
      title: json['title'] as String? ?? 'Food',
      calories: json['calories'] as int? ?? 0,
    );
  }
}
