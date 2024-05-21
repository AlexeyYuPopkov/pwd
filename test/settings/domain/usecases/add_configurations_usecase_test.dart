import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/settings/domain/add_configurations_usecase.dart';

class MockRemoteStorageConfigurationProvider extends Mock
    implements RemoteConfigurationProvider {}

class MockPinUsecase extends Mock implements PinUsecase {}

void main() {
  late final remoteStorageConfigurationProvider =
      MockRemoteStorageConfigurationProvider();
  late final pinUsecase = MockPinUsecase();

  final usecase = AddConfigurationsUsecase(
    remoteStorageConfigurationProvider: remoteStorageConfigurationProvider,
    pinUsecase: pinUsecase,
  );

  group('AddConfigurationsUsecase', () {
    test('test add configuration', () async {
      const config1 = GoogleDriveConfiguration(fileName: 'fileName1');
      const config2 = GitConfiguration(
        token: 'token',
        repo: 'repo',
        owner: 'owner',
        branch: 'branch',
        fileName: 'fileName',
      );

      final oldConfigurations = RemoteConfigurations.createOrThrow(
        configurations: const [config1],
      );

      when(
        () => remoteStorageConfigurationProvider.currentConfiguration,
      ).thenReturn(
        RemoteConfigurations.createOrThrow(configurations: const [config1]),
      );

      final newConfigurations = oldConfigurations.addAndCopy(config2);

      when(
        () => remoteStorageConfigurationProvider.setConfigurations(
          newConfigurations,
        ),
      ).thenAnswer((_) => Future.value());

      await usecase.execute(config2);

      verifyInOrder([
        () => remoteStorageConfigurationProvider.currentConfiguration,
        () => remoteStorageConfigurationProvider.setConfigurations(
              newConfigurations,
            ),
      ]);
    });

    test('test throws', () async {
      const config1 = GoogleDriveConfiguration(fileName: 'fileName1');
      const config2 = GitConfiguration(
        token: 'token',
        repo: 'repo',
        owner: 'owner',
        branch: 'branch',
        fileName: 'fileName',
      );

      final oldConfigurations = RemoteConfigurations.createOrThrow(
        configurations: const [config1],
      );

      when(
        () => remoteStorageConfigurationProvider.currentConfiguration,
      ).thenReturn(
        RemoteConfigurations.createOrThrow(configurations: const [config1]),
      );

      final newConfigurations = oldConfigurations.addAndCopy(config2);

      when(
        () => remoteStorageConfigurationProvider.setConfigurations(
          newConfigurations,
        ),
      ).thenThrow(Exception('reason'));

      final result = usecase.execute(config2);

      expect(result, throwsA(isA<Exception>()));

      verifyInOrder([
        () => remoteStorageConfigurationProvider.currentConfiguration,
        () => remoteStorageConfigurationProvider.setConfigurations(
              newConfigurations,
            ),
      ]);
    });
  });
}
