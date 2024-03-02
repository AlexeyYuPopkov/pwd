import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_page.dart';
import 'package:pwd/main.dart' as app;
import 'package:pwd/notes/data/datasource/realm_datasource_impl.dart';

import 'package:pwd/notes/presentation/edit_note/edit_note_screen.dart';
import 'pages/configurations_screen/configurations_screen_robot.dart';
import 'pages/configurations_screen/git_configuration_screen/git_configuration_test_data.dart';
import 'pages/edit_note_screen/edit_note_screen_robot.dart';
import 'pages/configurations_screen/git_configuration_screen/git_configuration_screen_robot.dart';
import 'pages/home_tabbar_screen/home_tabbar_robot.dart';
import 'pages/notes_list_screen/notes_list_screen_robot.dart';
import 'pages/pin_screen/pin_screen_robot.dart';
import 'pages/settings_screen/settings_robot.dart';
import 'tools/test_tools.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    DeveloperSettings.applay();

    final config = GitConfigurationTestData.createTestConfiguration();
    const hashUsecase = HashUsecase();
    final pinSha512 = hashUsecase.pinHash512(PinScreenRobot.pinStr);
    final db = RealmDatasourceImpl();
    db.deleteAll(target: config.getTarget(pin: Pin(pinSha512: pinSha512)));
  });

  testWidgets('Test Login and add note, then delete note with Git',
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
    await homeTabbarRobot.tapSettings();

    // Settings tap RemoteConfiguration item
    final settingsRobot = SettingsRobot(tester);
    await settingsRobot.checkInitialState();
    await settingsRobot.tapRemoteConfiguration();

    // Configurations Screen
    final configurationsScreenRobot = ConfigurationsScreenRobot(tester);
    await configurationsScreenRobot.checkInitialState();

    await configurationsScreenRobot.toggleGitConfiguration();

    // Git configuration
    final gitConfigurationScreenRobot = GitConfigurationScreenRobot(tester);
    await gitConfigurationScreenRobot.checkInitialState();
    await gitConfigurationScreenRobot.fillForm();
    await gitConfigurationScreenRobot.save();

    // Save configurations
    await configurationsScreenRobot.saveConfigurations();

    // Check return on Pin screen
    await enterPinRobot.checkInitialState();
    await enterPinRobot.fillFormAndLogin();

    // Check home screen with git enabled
    await homeTabbarRobot.checkGitEnabledState();

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
    // Go to configurations
    await settingsRobot.tapRemoteConfiguration();
    // Toggle git & save
    await configurationsScreenRobot.checkInitialState();
    await configurationsScreenRobot.toggleGitConfiguration();
    await configurationsScreenRobot.saveConfigurations();

    // Check on pin page
    await enterPinRobot.checkInitialState();
  });
}
