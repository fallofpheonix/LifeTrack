import 'package:lifetrack/data/models/base_health_entry.dart';
import 'package:lifetrack/data/models/enums/data_source.dart';

class MealEntry extends BaseHealthEntry {
  MealEntry({
    required this.id,
    required this.mealType,
    required this.title,
    required this.calories,
    DateTime? date, // Meals might default to 'now' but should be tracked
    super.source,
    super.createdAt,
    super.editedAt,
    super.deletedAt,
    super.entityVersion,
  }) : super(
          date: date ?? DateTime.now(),
        );

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
      ...toBaseJson(),
    };
  }

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(),
      mealType: json['mealType'] as String? ?? 'Snack',
      title: json['title'] as String? ?? 'Food',
      calories: json['calories'] as int? ?? 0,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      source: DataSource.values.asNameMap()[json['source']] ?? DataSource.manual,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      entityVersion: json['entityVersion'] as int? ?? 1,
    );
  }
}
