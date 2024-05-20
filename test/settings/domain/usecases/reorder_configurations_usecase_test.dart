import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/settings/domain/reorder_configurations_usecase.dart';

class MockRemoteConfigurationProvider extends Mock
    implements RemoteConfigurationProvider {}

void main() {
  group('ReorderConfigurationsUsecase - test', () {
    test('description', () async {
      const config1 = RemoteConfiguration.google(fileName: 'fileName1');
      const config2 = RemoteConfiguration.google(fileName: 'fileName2');
      const config3 = RemoteConfiguration.google(fileName: 'fileName3');

      final configurationProvider = MockRemoteConfigurationProvider();

      final sut = ReorderConfigurationsUsecase(
        remoteStorageConfigurationProvider: configurationProvider,
      );

      when(() => configurationProvider.currentConfiguration).thenReturn(
        RemoteConfigurations.createOrThrow(
          configurations: const [config1, config2, config3],
        ),
      );

      when(
        () => configurationProvider.setConfigurations(
          RemoteConfigurations.createOrThrow(
            configurations: const [config2, config3, config1],
          ),
        ),
      ).thenAnswer((_) async {});

      await sut.execute(oldIndex: 0, newIndex: 2);

      verifyInOrder([
        () => configurationProvider.currentConfiguration,
        () => configurationProvider.setConfigurations(
              RemoteConfigurations.createOrThrow(
                configurations: const [config2, config3, config1],
              ),
            ),
      ]);
    });
  });
}
