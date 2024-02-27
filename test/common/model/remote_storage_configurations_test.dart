import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';

const _gitConfiguration = GitConfiguration(
  token: '',
  repo: '',
  owner: '',
  branch: '',
  fileName: '',
);

const _googleDriveConfiguration = GoogleDriveConfiguration(fileName: '');

void main() {
  group('RemoteStorageConfigurations', () {
    test('Test empty state', () {
      var configuration = RemoteConfigurations.empty();

      expect(configuration.isNotEmpty, false);
      expect(configuration.isEmpty, true);
      expect(configuration.isEmpty, configuration.configurations.isEmpty);

      expect(configuration.hasConfiguration(ConfigurationType.git), false);
      expect(
        configuration.hasConfiguration(ConfigurationType.googleDrive),
        false,
      );

      expect(configuration.withType(ConfigurationType.git), null);
      expect(configuration.withType(ConfigurationType.googleDrive), null);
    });

    test(
      'Test add then remove',
      () {
        var configuration = RemoteConfigurations.empty();

        // Add Git
        configuration = configuration.copyAppendedType(_gitConfiguration);

        expect(configuration.isNotEmpty, true);
        expect(configuration.isEmpty, false);
        expect(configuration.isEmpty, configuration.configurations.isEmpty);

        expect(configuration.hasConfiguration(ConfigurationType.git), true);
        expect(
          configuration.hasConfiguration(ConfigurationType.googleDrive),
          false,
        );

        expect(
          configuration.withType(ConfigurationType.git),
          _gitConfiguration,
        );
        expect(configuration.withType(ConfigurationType.googleDrive), null);

        // Add Google drive
        configuration = configuration.copyAppendedType(
          _googleDriveConfiguration,
        );

        expect(configuration.isNotEmpty, true);
        expect(configuration.isEmpty, false);
        expect(configuration.isEmpty, configuration.configurations.isEmpty);

        expect(configuration.hasConfiguration(ConfigurationType.git), true);
        expect(
          configuration.hasConfiguration(ConfigurationType.googleDrive),
          true,
        );

        expect(
            configuration.withType(ConfigurationType.git), _gitConfiguration);
        expect(
          configuration.withType(ConfigurationType.googleDrive),
          _googleDriveConfiguration,
        );

        // Remove Git
        configuration = configuration.copyRemovedType(ConfigurationType.git);

        expect(configuration.isNotEmpty, true);
        expect(configuration.isEmpty, false);
        expect(configuration.isEmpty, configuration.configurations.isEmpty);

        expect(configuration.hasConfiguration(ConfigurationType.git), false);
        expect(
          configuration.hasConfiguration(ConfigurationType.googleDrive),
          true,
        );

        expect(configuration.withType(ConfigurationType.git), null);
        expect(
          configuration.withType(ConfigurationType.googleDrive),
          _googleDriveConfiguration,
        );

        // Remove Google drive
        configuration =
            configuration.copyRemovedType(ConfigurationType.googleDrive);

        expect(configuration.isNotEmpty, false);
        expect(configuration.isEmpty, true);
        expect(configuration.isEmpty, configuration.configurations.isEmpty);

        expect(configuration.hasConfiguration(ConfigurationType.git), false);
        expect(
          configuration.hasConfiguration(ConfigurationType.googleDrive),
          false,
        );

        expect(configuration.withType(ConfigurationType.git), null);
        expect(
          configuration.withType(ConfigurationType.googleDrive),
          null,
        );

        expect(configuration, RemoteConfigurations.empty());
      },
    );

    test('Multiple add protection', () {
      var configuration = RemoteConfigurations.empty();
      configuration = configuration.copyAppendedType(_gitConfiguration);
      configuration = configuration.copyAppendedType(
        _googleDriveConfiguration,
      );

      expect(configuration.hasConfiguration(ConfigurationType.git), true);
      expect(
        configuration.hasConfiguration(ConfigurationType.googleDrive),
        true,
      );
      expect(configuration.configurations.length, 2);

      configuration = configuration.copyAppendedType(_gitConfiguration);
      configuration = configuration.copyAppendedType(
        _googleDriveConfiguration,
      );

      expect(configuration.hasConfiguration(ConfigurationType.git), true);
      expect(
        configuration.hasConfiguration(ConfigurationType.googleDrive),
        true,
      );
      expect(configuration.configurations.length, 2);
    });
  });
}
