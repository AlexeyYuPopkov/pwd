// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteData _$NoteDataFromJson(Map<String, dynamic> json) => NoteData(
      id: json['id'] as String,
      notes: (json['notes'] as List<dynamic>)
          .map((e) => NoteItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NoteDataToJson(NoteData instance) => <String, dynamic>{
      'id': instance.id,
      'notes': instance.notes,
    };
