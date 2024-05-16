import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/settings/presentation/remote_configuration/git_configuration_screen/git_configuration_screen.dart';

import '../../../../test/settings/presentation/configurations_screen/git_configuration_screen_finders.dart';
import 'git_configuration_test_data.dart';

final class GitConfigurationScreenRobot {
  final _finders = GitConfigurationScreenFinders();

  Future<void> checkInitialState(WidgetTester tester) async {
    await tester.ensureVisible(_finders.tokenTextField);
    await tester.ensureVisible(_finders.repoTextField);
    await tester.ensureVisible(_finders.ownerTextField);
    await tester.ensureVisible(_finders.branchTextField);
    await tester.ensureVisible(_finders.fileNameTextField);
    await tester.ensureVisible(_finders.nextButton);

    expect(
      tester.widget<OutlinedButton>(_finders.nextButton).enabled,
      false,
    );
  }

  Future<void> fillForm(WidgetTester tester) async {
    final configuration = GitConfigurationTestData.createTestConfiguration();
    await tester.tap(_finders.tokenTextField);
    await tester.enterText(_finders.tokenTextField, configuration.token);
    await tester.pumpAndSettle();
    await tester.tap(_finders.repoTextField);
    await tester.enterText(_finders.repoTextField, configuration.repo);
    await tester.pumpAndSettle();
    await tester.tap(_finders.ownerTextField);
    await tester.enterText(_finders.ownerTextField, configuration.owner);
    await tester.pumpAndSettle();

    if (configuration.branch.isNotEmpty) {
      await tester.tap(_finders.branchTextField);
      await tester.enterText(_finders.branchTextField, configuration.branch);
      await tester.pumpAndSettle();
    }

    await tester.tap(_finders.fileNameTextField);
    await tester.enterText(_finders.fileNameTextField, configuration.fileName);

    await tester.pumpAndSettle();

    final context = tester.element(find.byType(GitConfigurationForm));
    FocusScope.of(context).unfocus();

    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester) async {
    await tester.tap(find.byType(GitConfigurationForm));
    final context = tester.element(find.byType(GitConfigurationForm));
    FocusScope.of(context).unfocus();
    await tester.pumpAndSettle();
    await tester.tap(_finders.nextButton);
  }

  Future<void> deleteConfiguration(WidgetTester tester) async {
    await tester.pumpAndSettle();

    await tester.tap(_finders.nextButton);
    await tester.pumpAndSettle();
    expect(_finders.deleteConfirmationDialog, findsOneWidget);
    expect(_finders.deleteConfirmationDialogOkButton, findsOneWidget);

    await tester.tap(_finders.deleteConfirmationDialogOkButton);

    await tester.pumpAndSettle();
  }
}
