// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_db_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutDbResponseData _$PutDbResponseDataFromJson(Map<String, dynamic> json) =>
    PutDbResponseData(
      content: PutDbResponseDataContent.fromJson(
          json['content'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PutDbResponseDataToJson(PutDbResponseData instance) =>
    <String, dynamic>{
      'content': instance.content,
    };

PutDbResponseDataContent _$PutDbResponseDataContentFromJson(
        Map<String, dynamic> json) =>
    PutDbResponseDataContent(
      sha: json['sha'] as String,
    );

Map<String, dynamic> _$PutDbResponseDataContentToJson(
        PutDbResponseDataContent instance) =>
    <String, dynamic>{
      'sha': instance.sha,
    };
