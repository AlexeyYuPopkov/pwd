// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_item_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteItemData _$NoteItemDataFromJson(Map<String, dynamic> json) => NoteItemData(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      content: json['content'] as String? ?? '',
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$NoteItemDataToJson(NoteItemData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'date': instance.date?.toIso8601String(),
    };
