import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/data/mappers/remote_configurations_mapper.dart';
import 'package:pwd/common/data/model/remote_storage_configurations_data.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';

void main() {
  const jsonStr =
      r'{"configurations":[{"type":"git","value":{"token":"token","repo":"repo","owner":"owner","branch":"branch","fileName":"file_name_git1"}},{"type":"git","value":{"token":"token","repo":"repo","owner":"owner","branch":"branch","fileName":"file_name_git2"}},{"type":"googleDrive","value":{"fileName":"file_name_google_drive1"}},{"type":"googleDrive","value":{"fileName":"file_name_google_drive2"}}]}';

  const git1 = RemoteConfiguration.git(
    token: 'token',
    repo: 'repo',
    owner: 'owner',
    branch: 'branch',
    fileName: 'file_name_git1',
  );

  const git2 = RemoteConfiguration.git(
    token: 'token',
    repo: 'repo',
    owner: 'owner',
    branch: 'branch',
    fileName: 'file_name_git2',
  );

  const googleDrive1 = RemoteConfiguration.google(
    fileName: 'file_name_google_drive1',
  );

  const googleDrive2 = RemoteConfiguration.google(
    fileName: 'file_name_google_drive2',
  );

  group('RemoteConfigurationsMapper', () {
    test('Domain to json str', () {
      final configs = RemoteConfigurations.createOrThrow(
        configurations: const [git1, git2, googleDrive1, googleDrive2],
      );

      final data = RemoteConfigurationsMapper.toData(configs);

      expect(data.configurations.length, 4);

      final actual = jsonEncode(data.toJson());

      expect(actual, jsonStr);
    });

    test('Json str to domain', () {
      final jsomMap = jsonDecode(jsonStr);
      final data = RemoteStorageConfigurationsData.fromJson(jsomMap);
      final domain = RemoteConfigurationsMapper.toDomain(data);
      expect(domain.configurations.length, 4);
      expect(
        domain.configurations,
        const [
          git1,
          git2,
          googleDrive1,
          googleDrive2,
        ],
      );
    });
  });
}
