import 'dart:async';
import 'dart:ui';
import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/home/presentation/home_tabbar/home_screen.dart';
import 'package:pwd/main.dart' as app;
import 'package:pwd/notes/data/datasource/realm_datasource/realm_local_repository_impl.dart';
import 'package:pwd/notes/data/datasource/realm_datasource/realm_provider/realm_provider_impl.dart';
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
  const secureStorageKey =
      'RemoteStorageConfigurationProvider.RemoteStorageConfigurationKey';
  final config = GoogleDriveTestData.createTestConfiguration();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  late StreamSubscription? pinSubscription;

  setUp(() async {
    DeveloperSettings.applay();

    const hashUsecase = HashUsecase();
    final pinSha512 = hashUsecase.pinHash512(PinScreenRobot.pinStr);
    final db = RealmLocalRepositoryImpl(realmProvider: RealmProviderImpl());
    db.deleteAll(target: config.getTarget(pin: Pin(pinSha512: pinSha512)));
    await const FlutterSecureStorage().delete(key: secureStorageKey);
  });

  tearDown(() async {
    pinSubscription?.cancel();
    await const FlutterSecureStorage().delete(key: secureStorageKey);
  });

  testWidgets('Test Login and add note, then delete note with Google Drive',
      (tester) async {
    app.main();

    await tester.pumpAndSettle();

    // Enter pin
    final enterPinRobot = PinScreenRobot();
    await enterPinRobot.checkInitialState(tester);
    await enterPinRobot.fillFormAndLogin(tester);

    // Home Tabbar tap Settings
    final homeTabbarRobot = HomeTabbarRobot();
    await homeTabbarRobot.checkInitialState(tester);

    // Configuration undefined screen: go to configurations
    final configurationUndefinedScreenRobot =
        ConfigurationUndefinedScreenRobot();
    await configurationUndefinedScreenRobot.checkInitialState(tester);
    await configurationUndefinedScreenRobot.tapButton(tester);

    // Configurations Screen
    final configurationsScreenRobot = ConfigurationsScreenRobot();
    await configurationsScreenRobot.checkNoDataPlaceholderState(tester);
    await configurationsScreenRobot.gotoNewGoogleDriveConfiguration(tester);

    // Google drive configuration screen
    final googleDriveConfigurationScreenRobot =
        GoogleDriveConfigurationScreenRobot(tester);
    await googleDriveConfigurationScreenRobot.checkInitialState();
    await googleDriveConfigurationScreenRobot.fillForm();
    await googleDriveConfigurationScreenRobot.save();

    // Save configurations
    // await configurationsScreenRobot.saveConfigurations();
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

          break;
        case EmptyPin():
          break;
      }
    });

    // Check home screen with git enabled
    await homeTabbarRobot.checkGoogleDriveEnabledState(tester, config: config);

    // Notes list screen
    final notesListScreenRobot = NotesListScreenRobot();
    await notesListScreenRobot.checkEmptyPageState(tester);
    await notesListScreenRobot.goToAddNotePage(tester);

    // Edit note screen
    final editNoteScreenRobot = EditNoteScreenRobot();
    await editNoteScreenRobot.checkInitialState(tester);
    await editNoteScreenRobot.fillFormAndSave(tester);

    expect(find.text(editNoteScreenRobot.titleText), findsOneWidget);
    expect(find.text(editNoteScreenRobot.descriptionText), findsOneWidget);

    // Go to edit note and delete note
    await notesListScreenRobot.goToEditNoteScreenWithTitle(
      tester,
      noteTitle: editNoteScreenRobot.titleText,
    );

    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(EditNoteScreen), findsOneWidget);

    await editNoteScreenRobot.deleteNote(tester);

    // Check note deleted
    await notesListScreenRobot.checkEmptyPageState(tester);

    // Go to settings
    await homeTabbarRobot.tapSettings(tester);

    // Settings tap RemoteConfiguration item
    final settingsRobot = SettingsRobot();
    await settingsRobot.checkInitialState(tester);
    await settingsRobot.tapRemoteConfiguration(tester);

    // Configurations
    await configurationsScreenRobot.gotoConfiguration(tester, config);
    await googleDriveConfigurationScreenRobot.deleteConfiguration();

    // Go to settings
    await configurationsScreenRobot.maybePop(tester);
    await settingsRobot.tapLogout(tester);

    await enterPinRobot.checkInitialState(tester);

    // ignore: avoid_print
    print(mockGoogleRepository.toShortString());

    const expectedCalls = '\n'
        'getFile: (GoogleDriveConfiguration,); GoogleDriveFile}\n'
        'downloadFile: (GoogleDriveFile,); Uint8List}\n'
        'updateRemote: (Uint8List,, GoogleDriveConfiguration,); GoogleDriveFile}\n'
        'getFile: (GoogleDriveConfiguration,); GoogleDriveFile}\n'
        'logout: (); Null}';
    expect(mockGoogleRepository.toShortString(), expectedCalls);
  });
}
