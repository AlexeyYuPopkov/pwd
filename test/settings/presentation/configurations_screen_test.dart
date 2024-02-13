import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/common/domain/model/app_configuration.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/unauth/presentation/configuration_screen/configurations_screen.dart';
import 'package:pwd/unauth/presentation/configuration_screen/git_configuration_form.dart';
import 'package:pwd/unauth/presentation/configuration_screen/google_drive_configuration_screen.dart';

class MockRemoteStorageConfigurationProvider extends Mock
    implements RemoteStorageConfigurationProvider {}

class MockRemoteStorageConfigurationProviderWithError
    implements RemoteStorageConfigurationProvider {
  @override
  Stream<RemoteStorageConfigurations> get configuration =>
      throw UnimplementedError();

  @override
  RemoteStorageConfigurations get currentConfiguration =>
      throw UnimplementedError();

  @override
  Future<void> dropConfiguration() => throw UnimplementedError();

  @override
  Future<void> setConfigurations(RemoteStorageConfigurations configurations) =>
      throw TestException();
}

class MockShouldCreateRemoteStorageFileUsecase extends Mock
    implements ShouldCreateRemoteStorageFileUsecase {}

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

  final remoteStorageConfigurations = RemoteStorageConfigurations(
    configurations: const [
      googleDriveConfiguration,
      gitConfiguration,
    ],
  );

  late final RemoteStorageConfigurationProvider
      remoteStorageConfigurationProvider;
  late final ShouldCreateRemoteStorageFileUsecase
      shouldCreateRemoteStorageFileUsecase;

  setUpAll(
    () {
      DiStorage.shared.bind<AppConfigurationProvider>(
        module: null,
        () => CustomMockAppConfigurationProvider(),
        lifeTime: const LifeTime.single(),
      );

      DiStorage.shared.bind<RemoteStorageConfigurationProvider>(
        module: null,
        () => MockRemoteStorageConfigurationProvider(),
        lifeTime: const LifeTime.single(),
      );

      DiStorage.shared.bind<ShouldCreateRemoteStorageFileUsecase>(
        module: null,
        () => MockShouldCreateRemoteStorageFileUsecase(),
        lifeTime: const LifeTime.single(),
      );

      remoteStorageConfigurationProvider = DiStorage.shared.resolve();

      shouldCreateRemoteStorageFileUsecase = DiStorage.shared.resolve();
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
    required _Finders finders,
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
    expect(finders.sendButton, findsOneWidget);

    expect(
      tester.widget<SwitchListTile>(finders.googleDriveSwitch).value,
      false,
    );
    expect(tester.widget<SwitchListTile>(finders.gitSwitch).value, false);
    expect(tester.widget<OutlinedButton>(finders.sendButton).enabled, false);
  }

  Future<void> switchOnGoogleDrive(
    WidgetTester tester, {
    required _Finders finders,
  }) async {
    await tester.tap(finders.googleDriveSwitch);

    await tester.pumpAndSettle();

    expect(
      tester.widget<SwitchListTile>(finders.googleDriveSwitch).value,
      true,
    );
    expect(tester.widget<SwitchListTile>(finders.gitSwitch).value, false);
    expect(tester.widget<OutlinedButton>(finders.sendButton).enabled, true);
  }

  Future<void> switchOnGit(
    WidgetTester tester, {
    required _Finders finders,
  }) async {
    await tester.tap(finders.gitSwitch);

    await tester.pumpAndSettle();

    expect(
        tester.widget<SwitchListTile>(finders.googleDriveSwitch).value, true);
    expect(tester.widget<SwitchListTile>(finders.gitSwitch).value, true);
    expect(tester.widget<OutlinedButton>(finders.sendButton).enabled, true);
  }

  group(
    'ConfigurationsScreen',
    () {
      testWidgets(
        'ConfigurationsScreen check main flow',
        (tester) async {
          final finders = _Finders();

          // Setup and show screen
          await setupAndShowScreen(tester, finders: finders);

          // Switch on Google Drive
          await switchOnGoogleDrive(tester, finders: finders);

          // Switch on Git
          await switchOnGit(tester, finders: finders);

          // Save configurations
          when(
            () => remoteStorageConfigurationProvider.setConfigurations(
              remoteStorageConfigurations,
            ),
          ).thenAnswer((_) => Future.value());

          when(() => shouldCreateRemoteStorageFileUsecase.setFlag(false));

          await tester.tap(finders.sendButton);

          await tester.pumpAndSettle();

          verify(
            () => remoteStorageConfigurationProvider.setConfigurations(
              remoteStorageConfigurations,
            ),
          );

          verify(
            () => shouldCreateRemoteStorageFileUsecase.setFlag(false),
          );
        },
      );

      testWidgets(
        'ConfigurationsScreen check main flow with error',
        (tester) async {
          DiStorage.shared.remove<RemoteStorageConfigurationProvider>();

          expect(
            DiStorage.shared.canResolve<RemoteStorageConfigurationProvider>(),
            false,
          );

          final remoteStorageConfigurationProvider =
              MockRemoteStorageConfigurationProviderWithError();

          DiStorage.shared.bind<RemoteStorageConfigurationProvider>(
            module: null,
            () => remoteStorageConfigurationProvider,
            lifeTime: const LifeTime.single(),
          );

          final finders = _Finders();

          // Setup and show screen
          await setupAndShowScreen(tester, finders: finders);

          // Switch on Google Drive
          await switchOnGoogleDrive(tester, finders: finders);

          // Switch on Git
          await switchOnGit(tester, finders: finders);

          // Save configurations

          await tester.tap(finders.sendButton);

          await tester.pumpAndSettle();

          final errorDialog = find.byKey(const Key('error_dialog_key'));

          expect(errorDialog, findsOneWidget);
          expect(find.text(TestException.messageText), findsOneWidget);

          verifyNever(
            () => shouldCreateRemoteStorageFileUsecase.setFlag(false),
          );
        },
      );
    },
  );
}

final class _Finders {
  final googleDriveSwitch = find.byKey(
    Key('configurations_screen_switch_key_${ConfigurationType.googleDrive.toString()}'),
  );

  final gitSwitch = find.byKey(
    Key('configurations_screen_switch_key_${ConfigurationType.git.toString()}'),
  );

  final sendButton = find.byKey(
    const Key('configurations_screen_next_button'),
  );
}

final class TestException extends AppError {
  static const messageText = 'error text';
  TestException() : super(message: messageText);
}
