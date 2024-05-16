import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';

void main() {
  group('RemoteConfigurations', () {
    test('Can add and remove', () {
      var sut = RemoteConfigurations.empty();
      const config1 = RemoteConfiguration.git(
        token: 'token1',
        repo: 'repo1',
        owner: 'owner1',
        branch: 'branch1',
        fileName: 'fileName1',
      );

      const config2 = RemoteConfiguration.git(
        token: 'token2',
        repo: 'repo2',
        owner: 'owner2',
        branch: 'branch2',
        fileName: 'fileName2',
      );

      const config3 = RemoteConfiguration.google(fileName: 'fileName3');

      const config4 = RemoteConfiguration.google(fileName: 'fileName4');

      sut = sut.addAndCopy(config1);
      sut = sut.addAndCopy(config2);
      expect(sut.configurations, [config1, config2]);
      sut = sut.addAndCopy(config3);
      sut = sut.addAndCopy(config4);

      expect(sut.isNotEmpty, true);
      expect(sut.configurations, [config1, config2, config3, config4]);

      sut = sut.removeAndCopy(config1);
      sut = sut.removeAndCopy(config3);

      expect(sut.configurations, [config2, config4]);

      sut = sut.removeAndCopy(config2);
      sut = sut.removeAndCopy(config4);

      expect(sut.isEmpty, true);
    });

    test('Can`t add dublicate', () {
      var sut = RemoteConfigurations.empty();
      const config1 = RemoteConfiguration.git(
        token: 'token1',
        repo: 'repo1',
        owner: 'owner1',
        branch: 'branch1',
        fileName: 'fileName1',
      );

      const config2 = RemoteConfiguration.git(
        token: 'token2',
        repo: 'repo2',
        owner: 'owner2',
        branch: 'branch2',
        fileName: 'fileName2',
      );

      sut = sut.addAndCopy(config1);
      sut = sut.addAndCopy(config2);
      expect(sut.configurations, [config1, config2]);

      expect(
        () => sut.addAndCopy(config2),
        throwsA(isA<DublicateError>()),
      );
    });

    test('Can`t add fileneme dublicate', () {
      var sut = RemoteConfigurations.empty();
      const config1 = RemoteConfiguration.git(
        token: 'token1',
        repo: 'repo1',
        owner: 'owner1',
        branch: 'branch1',
        fileName: 'fileName1',
      );

      const config2 = RemoteConfiguration.git(
        token: 'token2',
        repo: 'repo2',
        owner: 'owner2',
        branch: 'branch2',
        fileName: 'fileName1',
      );

      sut = sut.addAndCopy(config1);

      expect(sut.configurations, [config1]);

      expect(
        () => sut.addAndCopy(config2),
        throwsA(isA<FilenemeDublicateError>()),
      );
    });

    test('Can`t add more than 4', () {
      var sut = RemoteConfigurations.empty();
      const config1 = RemoteConfiguration.git(
        token: 'token1',
        repo: 'repo1',
        owner: 'owner1',
        branch: 'branch1',
        fileName: 'fileName1',
      );

      const config2 = RemoteConfiguration.git(
        token: 'token2',
        repo: 'repo2',
        owner: 'owner2',
        branch: 'branch2',
        fileName: 'fileName2',
      );

      const config3 = RemoteConfiguration.google(fileName: 'fileName3');

      const config4 = RemoteConfiguration.google(fileName: 'fileName4');

      const config5 = RemoteConfiguration.google(fileName: 'fileName5');

      sut = sut.addAndCopy(config1);
      sut = sut.addAndCopy(config2);
      sut = sut.addAndCopy(config3);
      sut = sut.addAndCopy(config4);

      expect(sut.configurations, [config1, config2, config3, config4]);

      expect(
        () => sut.addAndCopy(config5),
        throwsA(isA<MaxCountError>()),
      );
    });
  });
}
