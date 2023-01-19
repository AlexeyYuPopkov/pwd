import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pwd/common/data/model/remote_storage_configuration_data.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteStorageConfigurationProviderMacosImpl
    implements RemoteStorageConfigurationProvider {
  static const String _jsonSharedPreferencesKey =
      'RemoteStorageConfigurationProvider.RemoteStorageConfigurationKey';

  static const storage = FlutterSecureStorage();

  RemoteStorageConfigurationProviderMacosImpl();

  RemoteStorageConfiguration _configuration =
      const RemoteStorageConfiguration.empty();

  @override
  Future<RemoteStorageConfiguration> get configuration async {
    if (_configuration is RemoteStorageConfigurationEmpty) {
      _configuration = await _readConfiguration();
      return _configuration;
    } else {
      return _configuration;
    }
  }

  @override
  Future<void> setConfiguration(
    RemoteStorageConfiguration configuration,
  ) async {
    if (configuration is RemoteStorageConfigurationEmpty) {
      return dropConfiguration();
    } else {
      final data = RemoteStorageConfigurationData(
        token: configuration.token,
        repo: configuration.repo,
        owner: configuration.owner,
        branch: configuration.branch,
        fileName: configuration.fileName,
      );

      final jsonStr = jsonEncode(data.toJson());
      final storage = await SharedPreferences.getInstance();
      return storage
          .setString(_jsonSharedPreferencesKey, jsonStr)
          .then((_) => null);
    }
  }

  @override
  Future<void> dropConfiguration() async {
    final storage = await SharedPreferences.getInstance();
    return storage.remove(_jsonSharedPreferencesKey).then((_) => null);
  }

  Future<RemoteStorageConfiguration> _readConfiguration() async {
    final storage = await SharedPreferences.getInstance();
    final json = storage.getString(_jsonSharedPreferencesKey);

    if (json == null || json.isEmpty) {
      return const RemoteStorageConfiguration.empty();
    } else {
      final jsonMap = jsonDecode(json);
      final result = RemoteStorageConfigurationData.fromJson(jsonMap);

      if (result.token.isNotEmpty &&
          result.repo.isNotEmpty &&
          result.owner.isNotEmpty &&
          result.fileName.isNotEmpty) {
        return RemoteStorageConfiguration.configuration(
          token: result.token,
          repo: result.repo,
          owner: result.owner,
          branch: result.branch,
          fileName: result.fileName,
        );
      } else {
        return const RemoteStorageConfiguration.empty();
      }
    }
  }
}
