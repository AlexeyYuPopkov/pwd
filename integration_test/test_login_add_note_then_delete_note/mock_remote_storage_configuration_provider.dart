import 'package:flutter/foundation.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:rxdart/subjects.dart';

final class MockRemoteStorageConfigurationProvider
    implements RemoteStorageConfigurationProvider {
  MockRemoteStorageConfigurationProvider();

  @override
  BehaviorSubject<RemoteStorageConfigurations> configuration =
      BehaviorSubject.seeded(RemoteStorageConfigurations.empty());

  @override
  RemoteStorageConfigurations get currentConfiguration {
    if (kDebugMode) {
      print('RemoteStorageConfiguration:\n${configuration.value.toString()}');
    }
    return configuration.value;
  }

  @override
  Future<void> setConfiguration(
    RemoteStorageConfigurations configuration,
  ) async {
    this.configuration.add(configuration);
  }

  @override
  Future<void> dropConfiguration() async {
    configuration.add(RemoteStorageConfigurations.empty());
  }

  static GitConfiguration createTestConfiguration() => GitConfiguration(
        token: 'тэстghp_etoAa3QsCBr6VsтэстZ9TRpVJGXehQ9oтэстKS0hdbjM'
            .replaceAll('тэст', ''),
        repo: 'notes_storage_test',
        owner: 'AlexeyYuPopkov',
        branch: 'main',
        fileName: 'notes.json',
      );
}
