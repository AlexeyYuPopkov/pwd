import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/settings/presentation/configuration_screen/git_configuration_screen/git_configuration_form.dart';

import 'git_configuration_screen_finders.dart';
import 'git_configuration_test_data.dart';

final class GitConfigurationScreenRobot {
  GitConfigurationScreenRobot(this.tester);
  final WidgetTester tester;

  late final _finders = GitConfigurationScreenFinders();

  Future<void> checkInitialState() async {
    await Future.wait([
      tester.ensureVisible(_finders.tokenTextField),
      tester.ensureVisible(_finders.repoTextField),
      tester.ensureVisible(_finders.ownerTextField),
      tester.ensureVisible(_finders.branchTextField),
      tester.ensureVisible(_finders.fileNameTextField),
      tester.ensureVisible(_finders.nextButton),
    ]);

    expect(_finders.tokenTextField, findsOneWidget);
    expect(_finders.repoTextField, findsOneWidget);
    expect(_finders.ownerTextField, findsOneWidget);
    expect(_finders.branchTextField, findsOneWidget);
    expect(_finders.fileNameTextField, findsOneWidget);
    expect(_finders.nextButton, findsOneWidget);

    expect(
      tester.widget<OutlinedButton>(_finders.nextButton).enabled,
      false,
    );
  }

  Future<void> fillForm() async {
    await tester.pumpAndSettle();

    final configuration = GitConfigurationTestData.createTestConfiguration();

    await tester.tap(_finders.tokenTextField);
    await tester.enterText(_finders.tokenTextField, configuration.token);

    await tester.tap(_finders.repoTextField);
    await tester.enterText(_finders.repoTextField, configuration.repo);

    await tester.tap(_finders.ownerTextField);
    await tester.enterText(_finders.ownerTextField, configuration.owner);

    final branch = configuration.branch;
    if (branch != null && branch.isNotEmpty) {
      await tester.tap(_finders.branchTextField);
      await tester.enterText(_finders.branchTextField, branch);
    }

    await tester.tap(_finders.fileNameTextField);
    await tester.enterText(_finders.fileNameTextField, configuration.fileName);

    await tester.tap(_finders.fileNameTextField);

    final context = tester.element(find.byType(GitConfigurationForm));
    FocusScope.of(context).unfocus();

    await tester.pumpAndSettle();
  }

  Future<void> save() async {
    await tester.tap(find.byType(GitConfigurationForm));
    final context = tester.element(find.byType(GitConfigurationForm));
    FocusScope.of(context).unfocus();
    await tester.pumpAndSettle();
    await tester.tap(_finders.nextButton);
  }
}
