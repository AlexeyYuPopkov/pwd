import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';

void main() {
  group('RemoteConfigurations', () {
    test('withId - empty', () {
      final configs = RemoteConfigurations.empty();
      final result = configs.withId('any');
      expect(result, null);
    });

    test('withId - not empty', () {
      const config1 = GoogleDriveConfiguration(fileName: 'fileName1');
      const config2 = GitConfiguration(
        token: 'token',
        repo: 'repo',
        owner: 'owner',
        branch: 'branch',
        fileName: 'fileName',
      );

      final configs = RemoteConfigurations.createOrThrow(
        configurations: const [config1, config2],
      );

      expect(configs.withId(config1.id), isA<GoogleDriveConfiguration>());
      expect(configs.withId(config2.id), isA<GitConfiguration>());
      expect(configs.withId('any'), null);
    });
  });
}
