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
      timestamp: json['timestamp'] as int? ?? 0,
    );

Map<String, dynamic> _$RemoteDbDataToJson(RemoteDbData instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'timestamp': instance.timestamp,
    };

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
