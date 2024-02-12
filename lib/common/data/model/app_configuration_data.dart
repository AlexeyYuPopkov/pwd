import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'app_configuration_data.g.dart';

@immutable
@JsonSerializable()
final class AppConfigurationData {
  @JsonKey(name: 'proxyData', defaultValue: null)
  final ProxyAppConfigurationData? proxyData;

  @JsonKey(name: 'showRawErrors', defaultValue: false)
  final bool showRawErrors;

  const AppConfigurationData({
    required this.proxyData,
    required this.showRawErrors,
  });

  factory AppConfigurationData.fromJson(Map<String, dynamic> json) =>
      _$AppConfigurationDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigurationDataToJson(this);
}

@immutable
@JsonSerializable()
final class ProxyAppConfigurationData {
  @JsonKey(name: 'ip', defaultValue: '')
  final String ip;

  @JsonKey(name: 'port', defaultValue: '')
  final String port;

  const ProxyAppConfigurationData({
    required this.ip,
    required this.port,
  });

  factory ProxyAppConfigurationData.fromJson(Map<String, dynamic> json) =>
      _$ProxyAppConfigurationDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProxyAppConfigurationDataToJson(this);
}
