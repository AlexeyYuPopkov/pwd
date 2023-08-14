import 'package:flutter/foundation.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';

class MockRemoteStorageConfigurationProvider
    implements RemoteStorageConfigurationProvider {
  MockRemoteStorageConfigurationProvider();

  RemoteStorageConfiguration _configuration =
      const RemoteStorageConfiguration.empty();

  @override
  Future<RemoteStorageConfiguration> get configuration async {
    if (kDebugMode) {
      print('RemoteStorageConfiguration:\n${_configuration.toString()}');
    }
    return _configuration;
  }

  @override
  Future<void> setConfiguration(
    RemoteStorageConfiguration configuration,
  ) async {
    if (kDebugMode) {
      print('RemoteStorageConfiguration1:\n${_configuration.toString()}');
    }
    _configuration = configuration;
  }

  @override
  Future<void> dropConfiguration() async {
    _configuration = const RemoteStorageConfiguration.empty();
  }

  static RemoteStorageConfiguration createTestConfiguration() =>
      const RemoteStorageConfiguration.configuration(
        token: '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',
        repo: 'notes_storage_test',
        owner: 'AlekseiiPopkov',
        branch: 'main',
        fileName: 'notes.json',
      );
}
