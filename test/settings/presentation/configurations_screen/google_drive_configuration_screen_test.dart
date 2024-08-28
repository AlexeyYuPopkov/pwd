import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/settings/domain/add_configurations_usecase.dart';
import 'package:pwd/settings/domain/remove_configurations_usecase.dart';
import 'package:pwd/settings/presentation/remote_configuration/google_drive_configuration_screen/google_drive_configuration_screen.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc_data.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc_state.dart';
import '../../../test_tools/app_configuration_provider_tool.dart';

import '../../../test_tools/test_tools.dart';
import 'google_drive_configuration_screen_finders.dart';
import 'mock_usecases.dart';

void main() {
  late AddConfigurationsUsecase addConfigurationsUsecase;
  late RemoveConfigurationsUsecase removeConfigurationsUsecase;
  late MockRemoteConfigurationProvider configProvider;

  final finders = GoogleDriveConfigurationScreenFinders();

  const fileName = 'test_file_name';
  const configuration = GoogleDriveConfiguration(
    fileName: fileName,
  );

  setUp(
    () {
      AppConfigurationProviderTool.bindAppConfigurationProvider();

      DiStorage.shared.bind<RemoteConfigurationProvider>(
        module: null,
        () => MockRemoteConfigurationProvider(),
        lifeTime: const LifeTime.single(),
      );

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
      configProvider = DiStorage.shared.resolve<RemoteConfigurationProvider>()
          as MockRemoteConfigurationProvider;
    },
  );

  tearDown(
    () => DiStorage.shared.removeAll(),
  );

  Future<void> setupAndShowScreen(
    WidgetTester tester, {
    required GoogleDriveConfigurationScreenFinders finders,
    required String? configId,
  }) async {
    await tester.pumpWidget(
      CreateApp.createMaterialApp(
        child: GoogleDriveConfigurationScreen(
          configId: configId,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(finders.screen, findsOneWidget);
  }

  Future<void> fillForm(
    WidgetTester tester, {
    required GoogleDriveConfigurationScreenFinders finders,
    required GoogleDriveConfiguration config,
  }) async {
    final textFieldWidget = finders.filenameTextFormFieldWidget(tester);

    expect(textFieldWidget!.controller!.text.isEmpty, true);
    expect(textFieldWidget.readOnly, false);
    expect(textFieldWidget.enabled, true);

    await tester.tap(finders.filenameTextField);
    await tester.enterText(finders.filenameTextField, config.fileName);
    await tester.pumpAndSettle();

    expect(textFieldWidget.controller!.text, config.fileName);
  }

  group('GoogleDriveConfigurationScreen', () {
    testWidgets(
      'New configuration',
      (tester) async {
        await setupAndShowScreen(tester, finders: finders, configId: null);

        expect(finders.filenameTextField, findsOneWidget);
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
        await setupAndShowScreen(tester, finders: finders, configId: null);

        final usecase =
            addConfigurationsUsecase as MockAddConfigurationsUsecase;

        usecase.initialConfigurations = RemoteConfigurations.createOrThrow(
          configurations: const [
            GoogleDriveConfiguration(fileName: fileName),
          ],
        );

        expect(finders.filenameTextField, findsOneWidget);
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
        await configProvider.setConfigurations(
          RemoteConfigurations.createOrThrow(
            configurations: const [configuration],
          ),
        );

        await setupAndShowScreen(
          tester,
          finders: finders,
          configId: configuration.id,
        );

        final didSetMockConfig = await tester.runAsync(() {
          return configProvider.setConfigCompleter.future;
        });

        final didGetMockConfig = await tester.runAsync(() {
          return configProvider.getConfigCompleter.future;
        });

        expect(didSetMockConfig, true);
        expect(didGetMockConfig, true);

        await tester.pumpAndSettle();

        expect(finders.filenameTextField, findsOneWidget);
        expect(finders.nextButton, findsOneWidget);
        expect(finders.nextButtonWidget(tester)?.enabled, true);

        expect(
          finders.bloc(tester).data.mode,
          SetConfigurationBlocMode.editConfiguration,
        );

        final textFieldWidget = finders.filenameTextFormFieldWidget(tester);

        expect(textFieldWidget!.controller!.text, fileName);

        expect(textFieldWidget.readOnly, true);

        await tester.tap(finders.nextButton);

        await tester.pumpAndSettle();

        expect(finders.deleteConfirmationDialog, findsOneWidget);
        expect(finders.deleteConfirmationDialogOkButton, findsOneWidget);

        await tester.tap(finders.deleteConfirmationDialogOkButton);

        await tester.pumpAndSettle();

        expect(finders.bloc(tester).state is SavedState, true);
        final usecase =
            removeConfigurationsUsecase as MockRemoveConfigurationsUsecase;

        expect(
          usecase.calls.first == configuration,
          true,
        );
      },
    );

    testWidgets(
      'Show error',
      (tester) async {
        const fileName = 'test_file_name';
        const initialConfiguration = GoogleDriveConfiguration(
          fileName: fileName,
        );

        await configProvider.setConfigurations(
          RemoteConfigurations.createOrThrow(
            configurations: const [configuration],
          ),
        );

        await setupAndShowScreen(
          tester,
          finders: finders,
          configId: initialConfiguration.id,
        );

        final didSetMockConfig = await tester.runAsync(() {
          return configProvider.setConfigCompleter.future;
        });

        final didGetMockConfig = await tester.runAsync(() {
          return configProvider.getConfigCompleter.future;
        });

        expect(didSetMockConfig, true);
        expect(didGetMockConfig, true);

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

        await tester.pumpAndSettle();

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
