// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_db_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteDbData _$RemoteDbDataFromJson(Map<String, dynamic> json) => RemoteDbData(
      notes: (json['notes'] as List<dynamic>?)
              ?.map((e) => NoteItemData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$RemoteDbDataToJson(RemoteDbData instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'date': instance.date?.toIso8601String(),
    };
