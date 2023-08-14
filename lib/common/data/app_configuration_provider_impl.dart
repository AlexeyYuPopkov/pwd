import 'dart:convert';
import 'package:pwd/common/domain/app_configuration_provider.dart';
import 'package:pwd/common/domain/model/app_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigurationProviderImpl implements AppConfigurationProvider {
  static const String _jsonSharedPreferencesKey =
      'AppConfigurationProvider.AppConfigurationKey';

  static AppConfigurationProviderImpl? _instance;

  const AppConfigurationProviderImpl._();

  factory AppConfigurationProviderImpl() =>
      _instance ??= const AppConfigurationProviderImpl._();

  @override
  Future<AppConfiguration> get appConfiguration async {
    final storage = await SharedPreferences.getInstance();
    final json = storage.getString(_jsonSharedPreferencesKey);

    if (json == null || json.isEmpty) {
      return const AppConfiguration(proxyIp: null, proxyPort: null);
    } else {
      final jsonMap = jsonDecode(json);
      return _Tools.appConfigurationFromJson(jsonMap);
    }
  }

  @override
  Future<void> setEnvironment(AppConfiguration enviroment) async {
    final jsonMap = enviroment.toJson();
    final jsonStr = jsonEncode(jsonMap);
    final storage = await SharedPreferences.getInstance();
    storage.setString(_jsonSharedPreferencesKey, jsonStr);
  }

  @override
  Future<void> resetEnvironment() async {
    final storage = await SharedPreferences.getInstance();
    storage.remove(_jsonSharedPreferencesKey);
  }
}

// Tools
extension _Tools on AppConfiguration {
  Map<String, String> toJson() => {
        if (proxyIp is String && proxyIp?.isNotEmpty == true) 'pxyIp': proxyIp!,
        if (proxyPort is String && proxyPort?.isNotEmpty == true)
          'pxyPort': proxyPort!,
      };

  static AppConfiguration appConfigurationFromJson(Map<String, dynamic> json) {
    final proxyIp = json['pxyIp'];
    final proxyPort = json['pxyPort'];

    return AppConfiguration(
      proxyIp: proxyIp is String && proxyIp.isNotEmpty ? proxyIp : null,
      proxyPort: proxyPort is String && proxyPort.isNotEmpty ? proxyPort : null,
    );
  }
}
