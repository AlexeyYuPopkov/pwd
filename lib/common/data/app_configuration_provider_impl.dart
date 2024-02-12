import 'dart:convert';
import 'package:pwd/common/data/mappers/app_configuration_mapper.dart';
import 'package:pwd/common/data/model/app_configuration_data.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';
import 'package:pwd/common/domain/model/app_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigurationProviderImpl implements AppConfigurationProvider {
  static const String _jsonSharedPreferencesKey =
      'AppConfigurationProvider.AppConfigurationKey';

  static AppConfigurationProviderImpl? _instance;

  AppConfigurationProviderImpl._() {
    final _ = getAppConfiguration();
  }

  factory AppConfigurationProviderImpl() =>
      _instance ??= AppConfigurationProviderImpl._();

  @override
  AppConfiguration currentConfiguration =
      AppConfiguration.defaultConfiguration();

  @override
  Future<AppConfiguration> getAppConfiguration() async {
    final storage = await SharedPreferences.getInstance();
    final json = storage.getString(_jsonSharedPreferencesKey);

    final result = json == null || json.isEmpty
        ? AppConfiguration.defaultConfiguration()
        : AppConfigurationMapper.toDomain(
            AppConfigurationData.fromJson(
              jsonDecode(json),
            ),
          );

    currentConfiguration = result;

    return result;
  }

  @override
  Future<void> setEnvironment(AppConfiguration enviroment) async {
    final jsonMap = AppConfigurationMapper.toData(enviroment).toJson();
    final jsonStr = jsonEncode(jsonMap);
    final storage = await SharedPreferences.getInstance();
    storage.setString(_jsonSharedPreferencesKey, jsonStr);
    final _ = getAppConfiguration();
  }

  // @override
  // Future<void> resetEnvironment() async {
  //   final storage = await SharedPreferences.getInstance();
  //   storage.remove(_jsonSharedPreferencesKey);
  //   final _ = getAppConfiguration();
  // }
}
