// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_configuration_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigurationData _$AppConfigurationDataFromJson(
        Map<String, dynamic> json) =>
    AppConfigurationData(
      proxyData: json['proxyData'] == null
          ? null
          : ProxyAppConfigurationData.fromJson(
              json['proxyData'] as Map<String, dynamic>),
      showRawErrors: json['showRawErrors'] as bool? ?? false,
    );

Map<String, dynamic> _$AppConfigurationDataToJson(
        AppConfigurationData instance) =>
    <String, dynamic>{
      'proxyData': instance.proxyData,
      'showRawErrors': instance.showRawErrors,
    };

ProxyAppConfigurationData _$ProxyAppConfigurationDataFromJson(
        Map<String, dynamic> json) =>
    ProxyAppConfigurationData(
      ip: json['proxyIp'] as String? ?? '',
      port: json['proxyPort'] as String? ?? '',
    );

Map<String, dynamic> _$ProxyAppConfigurationDataToJson(
        ProxyAppConfigurationData instance) =>
    <String, dynamic>{
      'proxyIp': instance.ip,
      'proxyPort': instance.port,
    };
