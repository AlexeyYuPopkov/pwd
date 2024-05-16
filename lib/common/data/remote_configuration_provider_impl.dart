import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pwd/common/data/mappers/remote_configurations_mapper.dart';
import 'package:pwd/common/data/model/remote_storage_configurations_data.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

final class RemoteConfigurationProviderImpl
    implements RemoteConfigurationProvider {
  static const String _jsonSharedPreferencesKey =
      'RemoteStorageConfigurationProvider.RemoteStorageConfigurationKey';

  final storage = const FlutterSecureStorage();

  RemoteConfigurations _currentConfiguration = RemoteConfigurations.empty();

  RemoteConfigurationProviderImpl() {
    _readConfiguration().then(
      (e) => _currentConfiguration = e,
    );
  }

  @override
  RemoteConfigurations get currentConfiguration => _currentConfiguration;

  @override
  Future<void> setConfigurations(
    RemoteConfigurations configurations,
  ) async {
    // print('TODO: remove storage with secure');
    if (configurations.isNotEmpty) {
      final data = RemoteConfigurationsMapper.toData(configurations);

      final jsonStr = jsonEncode(data.toJson());
      // final storage = await SharedPreferences.getInstance();
      // return storage.setString(_jsonSharedPreferencesKey, jsonStr).then(
      //   (isSuccess) {
      //     assert(isSuccess);

      //     if (isSuccess) {
      //       _currentConfiguration = configurations;
      //     }
      //   },
      // );

      return storage
          .write(
            key: _jsonSharedPreferencesKey,
            value: jsonStr,
          )
          .then(
            (_) => _readConfiguration().then(
              (e) => _currentConfiguration = e,
            ),
          );
    } else {
      return storage.delete(key: _jsonSharedPreferencesKey).then(
            (_) => _currentConfiguration = RemoteConfigurations.empty(),
          );
    }
  }

// Private
  Future<RemoteConfigurations> _readConfiguration() async {
    // final storage = await SharedPreferences.getInstance();
    // final json = storage.getString(_jsonSharedPreferencesKey);
    final json = await storage.read(key: _jsonSharedPreferencesKey);

    if (json == null || json.isEmpty) {
      return RemoteConfigurations.empty();
    } else {
      final jsonMap = jsonDecode(json);
      final data = RemoteStorageConfigurationsData.fromJson(jsonMap);

      return RemoteConfigurationsMapper.toDomain(data);
    }
  }
}
