import 'dart:async';
import 'dart:ui';
import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_page.dart';
import 'package:pwd/main.dart' as app;
import 'package:pwd/notes/data/datasource/realm_datasource_impl.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/presentation/di/google_and_realm_di.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_screen.dart';
import 'pages/configuration_undefined_screen/configuration_undefined_screen_robot.dart';
import 'pages/configurations_screen/configurations_screen_robot.dart';
import 'pages/configurations_screen/google_drive_configuration_screen/google_drive_configuration_screen_robot.dart';
import 'pages/configurations_screen/google_drive_configuration_screen/google_drive_test_data.dart';
import 'pages/configurations_screen/google_drive_configuration_screen/mock_google_repository.dart';
import 'pages/edit_note_screen/edit_note_screen_robot.dart';

import 'pages/home_tabbar_screen/home_tabbar_robot.dart';
import 'pages/notes_list_screen/notes_list_screen_robot.dart';
import 'pages/pin_screen/pin_screen_robot.dart';

import 'pages/settings_screen/settings_robot.dart';
import 'tools/test_tools.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  late StreamSubscription? pinSubscription;

  setUp(() async {
    DeveloperSettings.applay();

    final config = GoogleDriveTestData.createTestConfiguration();
    const hashUsecase = HashUsecase();
    final pinSha512 = hashUsecase.pinHash512(PinScreenRobot.pinStr);
    final db = RealmDatasourceImpl();
    db.deleteAll(target: config.getTarget(pin: Pin(pinSha512: pinSha512)));
  });

  tearDown(() {
    pinSubscription?.cancel();
  });

  testWidgets('Test Login and add note, then delete note with Google Drive',
      (tester) async {
    app.main();

    await tester.pumpAndSettle();

    // Enter pin
    final enterPinRobot = PinScreenRobot(tester);
    await enterPinRobot.checkInitialState();

    await enterPinRobot.fillFormAndLogin();

    // Home Tabbar tap Settings
    final homeTabbarRobot = HomeTabbarRobot(tester);
    await homeTabbarRobot.checkInitialState();

    // Configuration undefined screen: go to configurations
    final configurationUndefinedScreenRobot =
        ConfigurationUndefinedScreenRobot(tester);
    await configurationUndefinedScreenRobot.checkInitialState();
    await configurationUndefinedScreenRobot.tapButton();

    // Configurations Screen
    final configurationsScreenRobot = ConfigurationsScreenRobot(tester);
    await configurationsScreenRobot.checkInitialState();
    await configurationsScreenRobot.toggleGoogleDriveConfiguration();

    // Google drive configuration screen
    final googleDriveConfigurationScreenRobot =
        GoogleDriveConfigurationScreenRobot(tester);
    await googleDriveConfigurationScreenRobot.checkInitialState();
    await googleDriveConfigurationScreenRobot.fillForm();
    await googleDriveConfigurationScreenRobot.save();

    // Save configurations
    await configurationsScreenRobot.saveConfigurations();
    final mockGoogleRepository = MockGoogleRepository();

    // final RemoteConfigurationProvider configurationProvider =
    //     DiStorage.shared.resolve();

    pinSubscription =
        DiStorage.shared.resolve<PinUsecase>().pinStream.listen((e) async {
      // Work around of google auth
      switch (e) {
        case Pin():
          Future.delayed(const Duration(milliseconds: 10)).then((value) {
            DiStorage.shared.bind<GoogleRepository>(
              module: null,
              () => mockGoogleRepository,
              lifeTime: const LifeTime.single(),
            );

            GoogleAndRealmDi().bindUsecases(DiStorage.shared);
          });

          // final configurations = configurationProvider.currentConfiguration;

          // final configuration =
          //     configurations.withType(ConfigurationType.googleDrive);

          // expect(configuration != null, true);

          // if (configuration == null) {
          //   return;
          // }

          // final RealmLocalRepository db = RealmDatasourceImpl();
          // await db.deleteAll(target: configuration.getTarget(pin: e));
          break;
        case EmptyPin():
          break;
      }
    });

    // Check return on Pin screen
    await enterPinRobot.checkInitialState();

    await enterPinRobot.fillFormAndLogin();

    // Check home screen with git enabled
    await homeTabbarRobot.checkGoogleDriveEnabledState();

    // Notes list screen
    final notesListScreenRobot = NotesListScreenRobot(tester);

    await notesListScreenRobot.checkEmptyPageState();
    await notesListScreenRobot.goToAddNotePage();

    // Edit note screen
    final editNoteScreenRobot = EditNoteScreenRobot(tester);

    await editNoteScreenRobot.checkInitialState();

    await editNoteScreenRobot.fillFormAndSave();

    expect(find.text(editNoteScreenRobot.titleText), findsOneWidget);
    expect(find.text(editNoteScreenRobot.descriptionText), findsOneWidget);

    // Go to edit note and delete note
    await notesListScreenRobot.goToEditNoteScreenWithTitle(
      editNoteScreenRobot.titleText,
    );

    await tester.pumpAndSettle();
    expect(find.byType(HomeTabbarPage), findsOneWidget);
    expect(find.byType(EditNoteScreen), findsOneWidget);

    await editNoteScreenRobot.deleteNote();

    // Check note deleted
    await notesListScreenRobot.checkEmptyPageState();

    // Go to settings

    await homeTabbarRobot.tapSettings();

    // Settings tap RemoteConfiguration item
    final settingsRobot = SettingsRobot(tester);
    await settingsRobot.checkInitialState();
    await settingsRobot.tapRemoteConfiguration();

    // Toggle git & save
    await configurationsScreenRobot.checkInitialState();
    await configurationsScreenRobot.toggleGoogleDriveConfiguration();
    await configurationsScreenRobot.saveConfigurations();

    // Check on pin page
    await enterPinRobot.checkInitialState();

    // ignore: avoid_print
    print(mockGoogleRepository.toShortString());

    const expectedCalls = '\n'
        'getFile: (GoogleDriveConfiguration,); GoogleDriveFile}\n'
        'downloadFile: (GoogleDriveFile,); Uint8List}\n'
        'updateRemote: (Uint8List,, GoogleDriveConfiguration,); GoogleDriveFile}\n'
        'getFile: (GoogleDriveConfiguration,); GoogleDriveFile}\n'
        'getFile: (GoogleDriveConfiguration,); GoogleDriveFile}\n'
        'downloadFile: (GoogleDriveFile,); Uint8List}\n'
        'updateRemote: (Uint8List,, GoogleDriveConfiguration,); GoogleDriveFile}\n'
        'getFile: (GoogleDriveConfiguration,); GoogleDriveFile}\n'
        'logout: (); Null}';
    expect(mockGoogleRepository.toShortString(), expectedCalls);
  });
}
