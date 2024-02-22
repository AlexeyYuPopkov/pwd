import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pwd/common/data/mappers/remote_configurations_mapper.dart';
import 'package:pwd/common/data/model/remote_storage_configurations_data.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class RemoteStorageConfigurationProviderImpl
    implements RemoteStorageConfigurationProvider {
  static const String _jsonSharedPreferencesKey =
      'RemoteStorageConfigurationProvider.RemoteStorageConfigurationKey';

  static const storage = FlutterSecureStorage();

  RemoteStorageConfigurations _currentConfiguration =
      RemoteStorageConfigurations.empty();

  RemoteStorageConfigurationProviderImpl() {
    _readConfiguration().then(
      (e) => _currentConfiguration = e,
    );
  }

  @override
  RemoteStorageConfigurations get currentConfiguration => _currentConfiguration;

  @override
  Future<void> setConfigurations(
    RemoteStorageConfigurations configurations,
  ) async {
    if (configurations.isNotEmpty) {
      final data = RemoteConfigurationsMapper.toData(configurations);

      final jsonStr = jsonEncode(data.toJson());
      final storage = await SharedPreferences.getInstance();
      return storage.setString(_jsonSharedPreferencesKey, jsonStr).then(
        (isSuccess) {
          assert(isSuccess);

          if (isSuccess) {
            _currentConfiguration = configurations;
          }
        },
      );
    } else {
      return dropConfiguration();
    }
  }

  @override
  Future<void> dropConfiguration() async {
    final storage = await SharedPreferences.getInstance();
    return storage.remove(_jsonSharedPreferencesKey).then(
      (isSuccess) {
        assert(isSuccess);

        if (isSuccess) {
          _currentConfiguration = RemoteStorageConfigurations.empty();
        }
      },
    );
  }

// Private
  Future<RemoteStorageConfigurations> _readConfiguration() async {
    final storage = await SharedPreferences.getInstance();
    final json = storage.getString(_jsonSharedPreferencesKey);

    if (json == null || json.isEmpty) {
      return RemoteStorageConfigurations.empty();
    } else {
      final jsonMap = jsonDecode(json);
      final data = RemoteStorageConfigurationsData.fromJson(jsonMap);

      return RemoteConfigurationsMapper.toDomain(data);
    }
  }
}
