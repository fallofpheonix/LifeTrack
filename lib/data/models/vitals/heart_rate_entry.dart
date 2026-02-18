import 'package:lifetrack/data/models/base_health_entry.dart';
import 'package:lifetrack/data/models/enums/data_source.dart';

class HeartRateEntry extends BaseHealthEntry {
  HeartRateEntry({
    required this.id,
    required this.bpm,
    required super.date,
    super.source,
    super.createdAt,
    super.editedAt,
    super.deletedAt,
    super.entityVersion,
  });

  final String id;
  final int bpm;

  bool get isTachycardia => bpm > 100;
  bool get isBradycardia => bpm < 60;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'bpm': bpm,
      ...toBaseJson(),
    };
  }

  factory HeartRateEntry.fromJson(Map<String, dynamic> json) {
    return HeartRateEntry(
      id: json['id'] as String,
      bpm: json['bpm'] as int,
      date: DateTime.parse(json['date'] as String),
      source: DataSource.values.asNameMap()[json['source']] ?? DataSource.manual,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      entityVersion: json['entityVersion'] as int? ?? 1,
    );
  }
}
