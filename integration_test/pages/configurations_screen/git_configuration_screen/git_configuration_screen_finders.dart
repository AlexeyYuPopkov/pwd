import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/settings/presentation/configuration_screen/git_configuration_screen/git_configuration_screen_test_helper.dart';

final class GitConfigurationScreenFinders {
  final tokenTextField = find.byKey(
    const Key(GitConfigurationScreenTestHelper.tokenTextField),
  );
  final repoTextField = find.byKey(
    const Key(GitConfigurationScreenTestHelper.repoTextField),
  );
  final ownerTextField = find.byKey(
    const Key(GitConfigurationScreenTestHelper.ownerTextField),
  );
  final branchTextField = find.byKey(
    const Key(GitConfigurationScreenTestHelper.branchTextField),
  );
  final fileNameTextField = find.byKey(
    const Key(GitConfigurationScreenTestHelper.fileNameTextField),
  );

  final nextButton = find.byKey(
    const Key(GitConfigurationScreenTestHelper.nextButton),
  );
}
