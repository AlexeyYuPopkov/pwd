// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_item_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteItemData _$NoteItemDataFromJson(Map<String, dynamic> json) => NoteItemData(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      content: json['content'] as String? ?? '',
      timestamp: json['timestamp'] as int,
    );

Map<String, dynamic> _$NoteItemDataToJson(NoteItemData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'timestamp': instance.timestamp,
    };

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
