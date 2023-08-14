import 'package:flutter/widgets.dart';

import 'package:flutter_test/flutter_test.dart';

import 'mock_remote_storage_configuration_provider.dart';

class SetRemoteConfigRobot {
  const SetRemoteConfigRobot(this.tester);
  final WidgetTester tester;

  Future<void> fillRemoteStorageConfigurationForm() async {
    await tester.pumpAndSettle();

    final tokenField = find.byKey(const Key('test_token_text_field'));
    final repoField = find.byKey(const Key('test_repo_text_field'));
    final ownerField = find.byKey(const Key('test_owner_text_field'));
    final branchField = find.byKey(const Key('test_branch_text_field'));
    final fileNameField = find.byKey(const Key('test_file_name_text_field'));
    final checkbox = find.byKey(
      const Key('test_remote_configuration_checkbox'),
    );
    final onEnterPinPageButton = find.byKey(
      const Key('test_on_enter_pin_page_button'),
    );

    await Future.wait([
      tester.ensureVisible(tokenField),
      tester.ensureVisible(repoField),
      tester.ensureVisible(ownerField),
      tester.ensureVisible(branchField),
      tester.ensureVisible(fileNameField),
      tester.ensureVisible(onEnterPinPageButton),
      tester.ensureVisible(checkbox),
    ]);

    expect(tokenField, findsOneWidget);
    expect(repoField, findsOneWidget);
    expect(ownerField, findsOneWidget);
    expect(branchField, findsOneWidget);
    expect(fileNameField, findsOneWidget);
    expect(checkbox, findsOneWidget);
    expect(onEnterPinPageButton, findsOneWidget);

    final configuration =
        MockRemoteStorageConfigurationProvider.createTestConfiguration();

    await tester.tap(tokenField);
    await tester.enterText(tokenField, configuration.token);

    await tester.tap(repoField);
    await tester.enterText(repoField, configuration.repo);

    await tester.tap(ownerField);
    await tester.enterText(ownerField, configuration.owner);

    final branch = configuration.branch;
    if (branch != null && branch.isNotEmpty) {
      await tester.tap(branchField);
      await tester.enterText(branchField, branch);
    }

    await tester.tap(fileNameField);
    await tester.enterText(fileNameField, configuration.fileName);

    await tester.tap(checkbox);

    await tester.pumpAndSettle();

    final confirmationDialogOkButton =
        find.byKey(const Key('test_ok_cancel_dialog_ok_button'));

    await tester.ensureVisible(confirmationDialogOkButton);

    await tester.tap(confirmationDialogOkButton);

    await tester.pumpAndSettle();

    await tester.tap(onEnterPinPageButton);

    await tester.pumpAndSettle();
  }

  Future<void> dropRemoteStorageConfigurationFromHomePage() async {
    await tester.pumpAndSettle();

    final settingsIcon = find.byKey(
      const Key('test_bottom_navigation_bar_settings_item_icon'),
    );

    await tester.ensureVisible(settingsIcon);

    await tester.tap(settingsIcon);

    await tester.pumpAndSettle();

    final remoteStorageSettingsMenuItem = find.byKey(
      const Key('test_remote_storage_settings_menu_item'),
    );

    await tester.ensureVisible(remoteStorageSettingsMenuItem);

    await tester.tap(remoteStorageSettingsMenuItem);

    await tester.pumpAndSettle();

    final dropRemoteStorageSettingsButton = find.byKey(
      const Key('test_drop_remote_storage_settings_button'),
    );

    await tester.ensureVisible(dropRemoteStorageSettingsButton);

    await tester.tap(dropRemoteStorageSettingsButton);

    await tester.pumpAndSettle();

    final confirmationDialogOkButton =
        find.byKey(const Key('test_ok_cancel_dialog_ok_button'));

    await tester.ensureVisible(confirmationDialogOkButton);

    await tester.tap(confirmationDialogOkButton);

    await Future.delayed(const Duration(seconds: 1));

    await tester.pumpAndSettle();
  }
}
