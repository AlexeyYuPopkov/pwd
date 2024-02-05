// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'git_configuration_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GitConfigurationData _$GitConfigurationDataFromJson(
        Map<String, dynamic> json) =>
    GitConfigurationData(
      token: json['token'] as String,
      repo: json['repo'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      branch: json['branch'] as String?,
      fileName: json['fileName'] as String? ?? '',
    );

Map<String, dynamic> _$GitConfigurationDataToJson(
        GitConfigurationData instance) =>
    <String, dynamic>{
      'token': instance.token,
      'repo': instance.repo,
      'owner': instance.owner,
      'branch': instance.branch,
      'fileName': instance.fileName,
    };

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
