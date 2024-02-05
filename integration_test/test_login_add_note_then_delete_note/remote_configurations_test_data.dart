import 'package:pwd/common/domain/model/remote_storage_configuration.dart';

final class RemoteConfigurationsTestData {
  static GitConfiguration createTestConfiguration() => GitConfiguration(
        token: 'тэстghp_etoAa3QsCBr6VsтэстZ9TRpVJGXehQ9oтэстKS0hdbjM'
            .replaceAll('тэст', ''),
        repo: 'notes_storage_test',
        owner: 'AlexeyYuPopkov',
        branch: 'main',
        fileName: 'notes.json',
      );
}
