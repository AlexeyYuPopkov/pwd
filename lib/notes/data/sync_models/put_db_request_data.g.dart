// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_db_request_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutDbRequestData _$PutDbRequestDataFromJson(Map<String, dynamic> json) =>
    PutDbRequestData(
      message: json['message'] as String,
      content: json['content'] as String,
      sha: json['sha'] as String?,
      committer:
          CommitterData.fromJson(json['committer'] as Map<String, dynamic>),
      branch: json['branch'] as String?,
    );

Map<String, dynamic> _$PutDbRequestDataToJson(PutDbRequestData instance) {
  final val = <String, dynamic>{
    'message': instance.message,
    'content': instance.content,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('sha', instance.sha);
  val['committer'] = instance.committer;
  writeNotNull('branch', instance.branch);
  return val;
}

CommitterData _$CommitterDataFromJson(Map<String, dynamic> json) =>
    CommitterData(
      name: json['name'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$CommitterDataToJson(CommitterData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
    };
