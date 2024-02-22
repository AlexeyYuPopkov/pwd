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
      ip: json['ip'] as String? ?? '',
      port: json['port'] as String? ?? '',
    );

Map<String, dynamic> _$ProxyAppConfigurationDataToJson(
        ProxyAppConfigurationData instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'port': instance.port,
    };
