import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/settings/domain/add_configurations_usecase.dart';
import 'package:pwd/settings/domain/remove_configurations_usecase.dart';
import 'package:pwd/settings/presentation/remote_configuration/git_configuration_screen/git_configuration_screen.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc_data.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc_state.dart';

import '../../../test_tools/app_configuration_provider_tool.dart';

import 'git_configuration_screen_finders.dart';
import 'mock_usecases.dart';

void main() {
  late AddConfigurationsUsecase addConfigurationsUsecase;
  late RemoveConfigurationsUsecase removeConfigurationsUsecase;

  final finders = GitConfigurationScreenFinders();

  const configuration = GitConfiguration(
    token: 'token',
    repo: 'repo',
    owner: 'owner',
    branch: 'branch',
    fileName: 'fileName',
  );

  setUp(
    () {
      AppConfigurationProviderTool.bindAppConfigurationProvider();

      DiStorage.shared.bind<AddConfigurationsUsecase>(
        module: null,
        () => MockAddConfigurationsUsecase(),
        lifeTime: const LifeTime.single(),
      );

      DiStorage.shared.bind<RemoveConfigurationsUsecase>(
        module: null,
        () => MockRemoveConfigurationsUsecase(),
        lifeTime: const LifeTime.single(),
      );

      addConfigurationsUsecase = DiStorage.shared.resolve();
      removeConfigurationsUsecase = DiStorage.shared.resolve();
    },
  );

  tearDown(
    () => DiStorage.shared.removeAll(),
  );

  Future<void> setupAndShowScreen(
    WidgetTester tester, {
    required GitConfigurationScreenFinders finders,
    required GitConfiguration? initial,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        // theme: lightThemeData,
        home: BlockingLoadingIndicator(
          child: GitConfigurationScreen(
            initial: initial,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(finders.screen, findsOneWidget);
  }

  Future<void> fillForm(
    WidgetTester tester, {
    required GitConfigurationScreenFinders finders,
    required GitConfiguration config,
  }) async {
    final tokenWidget = finders.tokenTextFieldWidget(tester);
    final repoWidget = finders.repoTextFieldWidget(tester);
    final ownerWidget = finders.ownerTextFieldWidget(tester);
    final branchWidget = finders.branchTextFieldWidget(tester);
    final fileNameWidget = finders.fileNameTextFieldWidget(tester);

    final textFields = [
      tokenWidget,
      repoWidget,
      ownerWidget,
      branchWidget,
      fileNameWidget,
    ];

    for (final e in textFields) {
      expect(e!.controller!.text.isEmpty, true);
      expect(e.readOnly, false);
    }

    await tester.tap(finders.tokenTextField);
    await tester.enterText(finders.tokenTextField, config.token);
    await tester.tap(finders.repoTextField);
    await tester.enterText(finders.repoTextField, config.repo);
    await tester.tap(finders.ownerTextField);
    await tester.enterText(finders.ownerTextField, config.owner);
    await tester.tap(finders.branchTextField);
    await tester.enterText(finders.branchTextField, config.branch);
    await tester.tap(finders.fileNameTextField);
    await tester.enterText(finders.fileNameTextField, config.fileName);

    await tester.pumpAndSettle();

    expect(tokenWidget!.controller!.text, configuration.token);
    expect(repoWidget!.controller!.text, configuration.repo);
    expect(ownerWidget!.controller!.text, configuration.owner);
    expect(branchWidget!.controller!.text, configuration.branch);
    expect(fileNameWidget!.controller!.text, configuration.fileName);
  }

  group('GitConfigurationScreen', () {
    testWidgets(
      'New configuration',
      (tester) async {
        await setupAndShowScreen(tester, finders: finders, initial: null);

        expect(finders.nextButton, findsOneWidget);
        expect(finders.nextButtonWidget(tester)?.enabled, false);
        expect(
          finders.bloc(tester).data.mode,
          SetConfigurationBlocMode.newConfiguration,
        );

        await fillForm(tester, finders: finders, config: configuration);

        expect(finders.nextButtonWidget(tester)?.enabled, true);

        await tester.tap(finders.nextButton);

        await tester.pumpAndSettle();

        expect(finders.bloc(tester).state is SavedState, true);

        final usecase =
            addConfigurationsUsecase as MockAddConfigurationsUsecase;

        expect(usecase.calls.first == configuration, true);
      },
    );

    testWidgets(
      'New configuration file dublicate',
      (tester) async {
        await setupAndShowScreen(tester, finders: finders, initial: null);

        expect(finders.nextButton, findsOneWidget);
        expect(finders.nextButtonWidget(tester)?.enabled, false);
        expect(
          finders.bloc(tester).data.mode,
          SetConfigurationBlocMode.newConfiguration,
        );

        final usecase =
            addConfigurationsUsecase as MockAddConfigurationsUsecase;

        usecase.initialConfigurations = RemoteConfigurations.createOrThrow(
          configurations: const [
            GitConfiguration(
              token: 'token1',
              repo: 'repo1',
              owner: 'owner1',
              branch: 'branch1',
              fileName: 'fileName',
            ),
          ],
        );

        await fillForm(tester, finders: finders, config: configuration);

        expect(finders.nextButtonWidget(tester)?.enabled, true);

        await tester.tap(finders.nextButton);

        await tester.pumpAndSettle();

        final state = finders.bloc(tester).state;
        expect(state is ErrorState, true);

        expect(usecase.calls.first == configuration, true);

        final errorDialog = find.byKey(
          const Key(DialogHelperTestHelper.errorDialog),
        );

        expect(errorDialog, findsOneWidget);
        expect((state as ErrorState).e is FilenemeDublicateError, true);
      },
    );

    testWidgets(
      'Existed configuration',
      (tester) async {
        await setupAndShowScreen(
          tester,
          finders: finders,
          initial: configuration,
        );

        expect(finders.nextButton, findsOneWidget);
        expect(finders.nextButtonWidget(tester)?.enabled, true);
        expect(
          finders.bloc(tester).data.mode,
          SetConfigurationBlocMode.editConfiguration,
        );

        final tokenWidget = finders.tokenTextFieldWidget(tester);
        final repoWidget = finders.repoTextFieldWidget(tester);
        final ownerWidget = finders.ownerTextFieldWidget(tester);
        final branchWidget = finders.branchTextFieldWidget(tester);
        final fileNameWidget = finders.fileNameTextFieldWidget(tester);

        final textFields = [
          tokenWidget,
          repoWidget,
          ownerWidget,
          branchWidget,
          fileNameWidget,
        ];

        for (final e in textFields) {
          expect(e!.controller!.text.isNotEmpty, true);
          expect(e.readOnly, true);
        }

        await tester.tap(finders.nextButton);

        await tester.pumpAndSettle();

        expect(finders.deleteConfirmationDialog, findsOneWidget);
        expect(finders.deleteConfirmationDialogOkButton, findsOneWidget);

        await tester.tap(finders.deleteConfirmationDialogOkButton);

        await tester.pumpAndSettle();

        expect(finders.bloc(tester).state is CommonState, true);

        final usecase =
            removeConfigurationsUsecase as MockRemoveConfigurationsUsecase;

        expect(usecase.calls.first == configuration, true);
      },
    );

    testWidgets(
      'Show error',
      (tester) async {
        await setupAndShowScreen(
          tester,
          finders: finders,
          initial: configuration,
        );

        await tester.tap(finders.nextButton);

        await tester.pumpAndSettle();

        expect(finders.deleteConfirmationDialog, findsOneWidget);
        expect(finders.deleteConfirmationDialogOkButton, findsOneWidget);

        final usecase =
            removeConfigurationsUsecase as MockRemoveConfigurationsUsecase;
        usecase.exeptions.add(_TestException());

        await tester.tap(finders.deleteConfirmationDialogOkButton);

        await tester.pumpAndSettle();

        expect(finders.bloc(tester).state is ErrorState, true);

        final errorDialog = find.byKey(
          const Key(DialogHelperTestHelper.errorDialog),
        );

        expect(errorDialog, findsOneWidget);
        expect(find.text(_TestException.messageText), findsOneWidget);

        expect(
          usecase.calls.first == configuration,
          true,
        );
      },
    );
  });
}

final class _TestException extends AppError {
  static const messageText = 'error text';
  _TestException() : super(message: messageText);
}
