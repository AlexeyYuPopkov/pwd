// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_storage_configuration_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteStorageConfigurationData _$RemoteStorageConfigurationDataFromJson(
        Map<String, dynamic> json) =>
    RemoteStorageConfigurationData(
      token: json['token'] as String,
      repo: json['repo'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      branch: json['branch'] as String?,
      fileName: json['fileName'] as String? ?? '',
    );

Map<String, dynamic> _$RemoteStorageConfigurationDataToJson(
        RemoteStorageConfigurationData instance) =>
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
