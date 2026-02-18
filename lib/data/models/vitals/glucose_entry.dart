import '../base_health_entry.dart';
import '../enums/data_source.dart';

enum GlucoseContext { fasting, postMeal, random }

class GlucoseEntry extends BaseHealthEntry {
  GlucoseEntry({
    required this.id,
    required this.levelMgDl,
    required this.context,
    required DateTime date,
    DataSource source = DataSource.manual,
    DateTime? createdAt,
    DateTime? editedAt,
    DateTime? deletedAt,
    int entityVersion = 1,
  }) : super(
          date: date,
          source: source,
          createdAt: createdAt,
          editedAt: editedAt,
          deletedAt: deletedAt,
          entityVersion: entityVersion,
        );

  final String id;
  final int levelMgDl; // STRICTLY mg/dL
  final GlucoseContext context;

  bool get isHigh {
    if (context == GlucoseContext.fasting) return levelMgDl > 126;
    if (context == GlucoseContext.postMeal) return levelMgDl > 200;
    return levelMgDl > 200; // Random/Post-meal
  }

  bool get isLow => levelMgDl < 70;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'levelMgDl': levelMgDl,
      'context': context.toString().split('.').last,
      ...toBaseJson(),
    };
  }

  factory GlucoseEntry.fromJson(Map<String, dynamic> json) {
    return GlucoseEntry(
      id: json['id'] as String,
      levelMgDl: json['levelMgDl'] as int,
      context: GlucoseContext.values.firstWhere(
            (GlucoseContext e) => e.toString().split('.').last == json['context'],
        orElse: () => GlucoseContext.random,
      ),
      date: DateTime.parse(json['date'] as String),
      source: DataSource.values.asNameMap()[json['source']] ?? DataSource.manual,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      entityVersion: json['entityVersion'] as int? ?? 1,
    );
  }
}
