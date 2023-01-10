// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_item_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteItemData _$NoteItemDataFromJson(Map<String, dynamic> json) => NoteItemData(
      id: json['id'] as String,
      title: NoteItemValueData.fromJson(json['title'] as Map<String, dynamic>),
      description: NoteItemValueData.fromJson(
          json['description'] as Map<String, dynamic>),
      content:
          NoteItemValueData.fromJson(json['content'] as Map<String, dynamic>),
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

NoteItemValueData _$NoteItemValueDataFromJson(Map<String, dynamic> json) =>
    NoteItemValueData(
      text: json['text'] as String,
      style: $enumDecode(_$NoteItemStyleEnumMap, json['style']),
    );

Map<String, dynamic> _$NoteItemValueDataToJson(NoteItemValueData instance) =>
    <String, dynamic>{
      'text': instance.text,
      'style': _$NoteItemStyleEnumMap[instance.style]!,
    };

const _$NoteItemStyleEnumMap = {
  NoteItemStyle.header: 'header',
  NoteItemStyle.body: 'body',
  NoteItemStyle.other: 'other',
};
