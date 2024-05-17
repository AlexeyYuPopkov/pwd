// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_storage_configurations_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteStorageConfigurationsData _$RemoteStorageConfigurationsDataFromJson(
        Map<String, dynamic> json) =>
    RemoteStorageConfigurationsData(
      configurations: (json['configurations'] as List<dynamic>)
          .map((e) =>
              RemoteStorageConfigurationBox.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RemoteStorageConfigurationsDataToJson(
        RemoteStorageConfigurationsData instance) =>
    <String, dynamic>{
      'configurations': instance.configurations,
    };

RemoteStorageConfigurationBox _$RemoteStorageConfigurationBoxFromJson(
        Map<String, dynamic> json) =>
    RemoteStorageConfigurationBox(
      type: $enumDecodeNullable(
              _$RemoteConfigurationTypeDataEnumMap, json['type']) ??
          RemoteConfigurationTypeData.unknown,
      value: json['value'],
    );

Map<String, dynamic> _$RemoteStorageConfigurationBoxToJson(
        RemoteStorageConfigurationBox instance) =>
    <String, dynamic>{
      'type': _$RemoteConfigurationTypeDataEnumMap[instance.type]!,
      'value': instance.value,
    };

const _$RemoteConfigurationTypeDataEnumMap = {
  RemoteConfigurationTypeData.git: 'git',
  RemoteConfigurationTypeData.googleDrive: 'googleDrive',
  RemoteConfigurationTypeData.unknown: 'unknown',
};
