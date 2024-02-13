import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/unauth/presentation/configuration_screen/configurations_screen.dart';
import 'package:pwd/unauth/presentation/configuration_screen/git_configuration_form.dart';
import 'package:pwd/unauth/presentation/configuration_screen/google_drive_configuration_screen.dart';

class MockRemoteStorageConfigurationProvider extends Mock
    implements RemoteStorageConfigurationProvider {}

class MockShouldCreateRemoteStorageFileUsecase extends Mock
    implements ShouldCreateRemoteStorageFileUsecase {}

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

  setUpAll(
    () {
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

  testWidgets(
    'MyWidget has a title and message',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlockingLoadingIndicator(
            child: ConfigurationsScreen(
              onRoute: dummyOnRoute,
            ),
          ),
        ),
      );

      final googleDriveSwitch = find.byKey(
        Key('configurations_screen_switch_key_${ConfigurationType.googleDrive.toString()}'),
      );

      final gitSwitch = find.byKey(
        Key('configurations_screen_switch_key_${ConfigurationType.git.toString()}'),
      );

      final sendButton = find.byKey(
        const Key('configurations_screen_next_button'),
      );

      await tester.pumpAndSettle();

      expect(googleDriveSwitch, findsOneWidget);
      expect(gitSwitch, findsOneWidget);
      expect(sendButton, findsOneWidget);

      expect(tester.widget<SwitchListTile>(googleDriveSwitch).value, false);
      expect(tester.widget<SwitchListTile>(gitSwitch).value, false);
      expect(tester.widget<OutlinedButton>(sendButton).enabled, false);

      // Switch on Google Drive
      await tester.tap(googleDriveSwitch);

      await tester.pumpAndSettle();

      expect(tester.widget<SwitchListTile>(googleDriveSwitch).value, true);
      expect(tester.widget<SwitchListTile>(gitSwitch).value, false);
      expect(tester.widget<OutlinedButton>(sendButton).enabled, true);

      // Switch on Git
      await tester.tap(gitSwitch);

      await tester.pumpAndSettle();

      expect(tester.widget<SwitchListTile>(googleDriveSwitch).value, true);
      expect(tester.widget<SwitchListTile>(gitSwitch).value, true);
      expect(tester.widget<OutlinedButton>(sendButton).enabled, true);

      // Save configurations

      final RemoteStorageConfigurationProvider
          remoteStorageConfigurationProvider = DiStorage.shared.resolve();
      final ShouldCreateRemoteStorageFileUsecase
          shouldCreateRemoteStorageFileUsecase = DiStorage.shared.resolve();

      final remoteStorageConfigurations = RemoteStorageConfigurations(
        configurations: const [
          googleDriveConfiguration,
          gitConfiguration,
        ],
      );

      when(
        () => remoteStorageConfigurationProvider.setConfigurations(
          remoteStorageConfigurations,
        ),
      ).thenAnswer((_) => Future.value());

      when(() => shouldCreateRemoteStorageFileUsecase.setFlag(false));

      await tester.tap(sendButton);

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
}
