// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_db_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDbResponseData _$GetDbResponseDataFromJson(Map<String, dynamic> json) =>
    GetDbResponseData(
      sha: json['sha'] as String? ?? '',
      content: json['content'] as String? ?? '',
      downloadUrl: json['download_url'] as String? ?? '',
    );

Map<String, dynamic> _$GetDbResponseDataToJson(GetDbResponseData instance) =>
    <String, dynamic>{
      'sha': instance.sha,
      'content': instance.content,
      'download_url': instance.downloadUrl,
    };
