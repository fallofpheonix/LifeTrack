import 'package:lifetrack/data/models/base_health_entry.dart';
import 'package:lifetrack/data/models/enums/data_source.dart';

class WeightEntry extends BaseHealthEntry {
  WeightEntry({
    required super.date,
    required this.weightKg,
    super.source,
    super.createdAt,
    super.editedAt,
    super.deletedAt,
    super.entityVersion,
  });


  final double weightKg;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'weightKg': weightKg,
      ...toBaseJson(),
    };
  }

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0.0,
      source: DataSource.values.asNameMap()[json['source']] ?? DataSource.manual,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      entityVersion: json['entityVersion'] as int? ?? 1,
    );
  }
}
