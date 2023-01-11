// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_db_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportDbData _$ExportDbDataFromJson(Map<String, dynamic> json) => ExportDbData(
      notes: (json['notes'] as List<dynamic>)
          .map((e) => NoteItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$ExportDbDataToJson(ExportDbData instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'date': instance.date?.toIso8601String(),
    };
