import 'package:lifetrack/data/models/base_health_entry.dart';
import 'package:lifetrack/data/models/enums/data_source.dart';

class HealthRecordEntry extends BaseHealthEntry {
  HealthRecordEntry({
    required this.id,
    required this.dateLabel,
    required this.condition,
    required this.vitals,
    required this.note,
    this.attachmentPath,
    DateTime? date, // Derived from dateLabel usually, but precise date needed for sorting
    super.source,
    super.createdAt,
    super.editedAt,
    super.deletedAt,
    super.entityVersion,
  }) : super(
          date: date ?? DateTime.tryParse(dateLabel) ?? DateTime.now(),
        );

  final String id;
  final String dateLabel;
  final String condition;
  final String vitals;
  final String note;
  final String? attachmentPath;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'dateLabel': dateLabel,
      'condition': condition,
      'vitals': vitals,
      'note': note,
      'attachmentPath': attachmentPath,
      ...toBaseJson(),
    };
  }

  factory HealthRecordEntry.fromJson(Map<String, dynamic> json) {
    return HealthRecordEntry(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      dateLabel: json['dateLabel'] as String? ?? '',
      condition: json['condition'] as String? ?? '',
      vitals: json['vitals'] as String? ?? '',
      note: json['note'] as String? ?? '',
      attachmentPath: json['attachmentPath'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      source: DataSource.values.asNameMap()[json['source']] ?? DataSource.manual,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      entityVersion: json['entityVersion'] as int? ?? 1,
    );
  }
}
