import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/common/domain/model/app_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/settings/domain/save_configurations_usecase.dart';
import 'package:pwd/settings/presentation/configuration_screen/configurations_screen.dart';
import 'package:pwd/settings/presentation/configuration_screen/git_configuration_screen/git_configuration_form.dart';
import 'package:pwd/settings/presentation/configuration_screen/google_drive_configuration_screen/google_drive_configuration_screen.dart';

import '../../../integration_test/pages/configurations_screen/configurations_screen_finders.dart';
import '../../test_tools/app_configuration_provider_tool.dart';

class MockRemoteStorageConfigurationProvider extends Mock
    implements RemoteConfigurationProvider {}

class MockSaveConfigurationsUsecase extends Mock
    implements SaveConfigurationsUsecase {}

class CustomMockAppConfigurationProvider extends AppConfigurationProvider {
  @override
  AppConfiguration get currentConfiguration => const AppConfiguration(
        proxyData: null,
        showRawErrors: false,
      );

  @override
  Future<void> dropEnvironment() => throw UnimplementedError();

  @override
  Future<AppConfiguration> getAppConfiguration() => throw UnimplementedError();

  @override
  Future<void> setEnvironment(AppConfiguration enviroment) =>
      throw UnimplementedError();
}

void main() {
  const gitConfiguration = GitConfiguration(
    token: '',
    repo: '',
    owner: '',
    branch: '',
    fileName: 'fileName',
  );

  const googleDriveConfiguration = GoogleDriveConfiguration(
    fileName: 'fileName',
  );

  final remoteStorageConfigurations = RemoteConfigurations(
    configurations: const [
      googleDriveConfiguration,
      gitConfiguration,
    ],
  );

  late final RemoteConfigurationProvider remoteStorageConfigurationProvider;

  late final SaveConfigurationsUsecase saveConfigurationsUsecase;

  setUpAll(
    () {
      AppConfigurationProviderTool.bindAppConfigurationProvider();

      DiStorage.shared.bind<RemoteConfigurationProvider>(
        module: null,
        () => MockRemoteStorageConfigurationProvider(),
        lifeTime: const LifeTime.single(),
      );

      DiStorage.shared.bind<SaveConfigurationsUsecase>(
        module: null,
        () => MockSaveConfigurationsUsecase(),
        lifeTime: const LifeTime.single(),
      );

      remoteStorageConfigurationProvider = DiStorage.shared.resolve();
      saveConfigurationsUsecase = DiStorage.shared.resolve();
    },
  );

  tearDownAll(
    () => DiStorage.shared.removeAll(),
  );

  Future dummyOnRoute(BuildContext context, Object route) async {
    if (route is OnSetupConfigurationRoute) {
      switch (route.type) {
        case ConfigurationType.git:
          return const GitConfigurationFormResult(
            configuration: gitConfiguration,
            needsCreateNewFile: false,
          );
        case ConfigurationType.googleDrive:
          return const GoogleDriveConfigurationFormResult(
            configuration: googleDriveConfiguration,
          );
      }
    }
  }

  Future<void> setupAndShowScreen(
    WidgetTester tester, {
    required ConfigurationsScreenFinders finders,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlockingLoadingIndicator(
          child: ConfigurationsScreen(
            onRoute: dummyOnRoute,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(finders.googleDriveSwitch, findsOneWidget);
    expect(finders.gitSwitch, findsOneWidget);
    expect(finders.nextButton, findsOneWidget);
    expect(tester.widget<OutlinedButton>(finders.nextButton).enabled, false);
  }

  void checkSwitchControlsAreOff(
    WidgetTester tester, {
    required ConfigurationsScreenFinders finders,
  }) {
    expect(tester.widget<SwitchListTile>(finders.gitSwitch).value, false);

    expect(
      tester.widget<SwitchListTile>(finders.googleDriveSwitch).value,
      false,
    );
  }

  Future<void> switchOnGoogleDrive(
    WidgetTester tester, {
    required ConfigurationsScreenFinders finders,
  }) async {
    await tester.tap(finders.googleDriveSwitch);

    await tester.pumpAndSettle();

    expect(
      tester.widget<SwitchListTile>(finders.googleDriveSwitch).value,
      true,
    );
    expect(tester.widget<SwitchListTile>(finders.gitSwitch).value, false);
  }

  Future<void> switchOnGit(
    WidgetTester tester, {
    required ConfigurationsScreenFinders finders,
  }) async {
    await tester.tap(finders.gitSwitch);

    await tester.pumpAndSettle();

    expect(
        tester.widget<SwitchListTile>(finders.googleDriveSwitch).value, true);
    expect(tester.widget<SwitchListTile>(finders.gitSwitch).value, true);
  }

  group(
    'ConfigurationsScreen',
    () {
      testWidgets(
        'Check main flow, initial remote configuration is empty',
        (tester) async {
          when(
            () => remoteStorageConfigurationProvider.currentConfiguration,
          ).thenReturn(
            RemoteConfigurations.empty(),
          );

          final finders = ConfigurationsScreenFinders();

          // Setup and show screen
          await setupAndShowScreen(tester, finders: finders);
          checkSwitchControlsAreOff(tester, finders: finders);

          // Switch on Google Drive
          await switchOnGoogleDrive(tester, finders: finders);
          expect(
            tester.widget<OutlinedButton>(finders.nextButton).enabled,
            true,
          );

          // Switch on Git
          await switchOnGit(tester, finders: finders);
          expect(
            tester.widget<OutlinedButton>(finders.nextButton).enabled,
            true,
          );

          // Save configurations
          when(
            () => saveConfigurationsUsecase.execute(
              configuration: remoteStorageConfigurations,
              shouldCreateNewGitFile: false,
            ),
          ).thenAnswer((_) => Future.value());

          await tester.tap(finders.nextButton);

          await tester.pumpAndSettle();

          verify(
            () => saveConfigurationsUsecase.execute(
              configuration: remoteStorageConfigurations,
              shouldCreateNewGitFile: false,
            ),
          );
        },
      );

      testWidgets(
        'Check main flow with error',
        (tester) async {
          final finders = ConfigurationsScreenFinders();

          // Setup and show screen
          await setupAndShowScreen(tester, finders: finders);

          // Switch on Google Drive
          await switchOnGoogleDrive(tester, finders: finders);
          expect(
            tester.widget<OutlinedButton>(finders.nextButton).enabled,
            true,
          );

          // Switch on Git
          await switchOnGit(tester, finders: finders);
          expect(
            tester.widget<OutlinedButton>(finders.nextButton).enabled,
            true,
          );

          // Save configurations
          when(
            () => saveConfigurationsUsecase.execute(
              configuration: remoteStorageConfigurations,
              shouldCreateNewGitFile: false,
            ),
          ).thenThrow(TestException());

          await tester.tap(finders.nextButton);

          await tester.pumpAndSettle();

          final errorDialog = find.byKey(
            const Key(DialogHelperTestHelper.errorDialog),
          );

          expect(errorDialog, findsOneWidget);
          expect(find.text(TestException.messageText), findsOneWidget);

          verify(
            () => saveConfigurationsUsecase.execute(
              configuration: remoteStorageConfigurations,
              shouldCreateNewGitFile: false,
            ),
          );
        },
      );

      testWidgets(
        'Check and uncheck configurations, initial remote configuration is not empty',
        (tester) async {
          when(
            () => remoteStorageConfigurationProvider.currentConfiguration,
          ).thenReturn(
            remoteStorageConfigurations,
          );

          final finders = ConfigurationsScreenFinders();

          // Setup and show screen
          await setupAndShowScreen(tester, finders: finders);
          // final gitFinder = finders.getSwitchFor(ConfigurationType.git);
          //  final googleDriveFinder = finders.getSwitchFor(ConfigurationType.googleDrive);
          expect(tester.widget<SwitchListTile>(finders.gitSwitch).value, true);

          expect(
            tester.widget<SwitchListTile>(finders.googleDriveSwitch).value,
            true,
          );
          // Switch off Google Drive
          await tester.tap(finders.googleDriveSwitch);

          await tester.pumpAndSettle();

          expect(
            tester.widget<SwitchListTile>(finders.googleDriveSwitch).value,
            false,
          );
          expect(tester.widget<SwitchListTile>(finders.gitSwitch).value, true);
          expect(
            tester.widget<OutlinedButton>(finders.nextButton).enabled,
            true,
          );

          // Switch off Git

          await tester.tap(finders.gitSwitch);

          await tester.pumpAndSettle();

          expect(
            tester.widget<SwitchListTile>(finders.googleDriveSwitch).value,
            false,
          );
          expect(tester.widget<SwitchListTile>(finders.gitSwitch).value, false);
          expect(
            tester.widget<OutlinedButton>(finders.nextButton).enabled,
            true,
          );

          // Switch on Google Drive
          await switchOnGoogleDrive(tester, finders: finders);
          expect(
            tester.widget<OutlinedButton>(finders.nextButton).enabled,
            true,
          );

          // Switch on Git
          await switchOnGit(tester, finders: finders);
          expect(
            tester.widget<OutlinedButton>(finders.nextButton).enabled,
            false,
          );
        },
      );
    },
  );
}

final class TestException extends AppError {
  static const messageText = 'error text';
  TestException() : super(message: messageText);
}
