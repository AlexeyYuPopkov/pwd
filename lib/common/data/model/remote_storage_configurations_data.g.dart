// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_storage_configurations_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteStorageConfigurationsData _$RemoteStorageConfigurationsDataFromJson(
        Map<String, dynamic> json) =>
    RemoteStorageConfigurationsData(
      git: json['git'] == null
          ? null
          : GitConfigurationData.fromJson(json['git'] as Map<String, dynamic>),
      googleDrive: json['googleDrive'] == null
          ? null
          : GoogleDriveConfigurationData.fromJson(
              json['googleDrive'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RemoteStorageConfigurationsDataToJson(
        RemoteStorageConfigurationsData instance) =>
    <String, dynamic>{
      'git': instance.git,
      'googleDrive': instance.googleDrive,
    };
