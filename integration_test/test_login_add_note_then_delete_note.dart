import 'dart:ui';
import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_page.dart';
import 'package:pwd/main.dart' as app;
import 'package:pwd/notes/data/datasource/database_path_provider_impl.dart';
import 'package:pwd/notes/data/datasource/sql_datasource_impl.dart';
import 'package:pwd/notes/data/mappers/db_note_mapper.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/configurations_screen/configurations_screen_robot.dart';
import 'pages/edit_note_screen/edit_note_screen_robot.dart';
import 'pages/git_configuration_screen/git_configuration_screen_robot.dart';
import 'pages/git_notes_list_screen/git_notes_list_screen_robot.dart';
import 'pages/home_tabbar_screen/home_tabbar_robot.dart';
import 'pages/pin_screen/pin_screen_robot.dart';
import 'pages/settings_screen/settings_robot.dart';

void adjustDI() {
  SharedPreferences.setMockInitialValues({
    'AppConfigurationProvider.AppConfigurationKey':
        '{"pxyIp": "127.0.0.1", "pxyPort": "8888"}',
    // 'AppConfigurationProvider.AppConfigurationKey': '',
  });
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final dbDataSource = SqlDatasourceImpl(
      databasePathProvider: DatabasePathProviderImpl(),
      mapper: DbNoteMapper(),
    );
    await dbDataSource.dropDb();
  });

  testWidgets('Test Login and add note, then delete note', (tester) async {
    app.main();

    final RemoteStorageConfigurationProvider
        remoteStorageConfigurationProvider = DiStorage.shared.resolve();

    await remoteStorageConfigurationProvider.dropConfiguration();

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

    // Adjust di
    adjustDI();

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

    // Git notes screen - goto add note
    final gitNotesListScreenRobot = GitNotesListScreenRobot(tester);
    await gitNotesListScreenRobot.checkEmptyPageState();
    await gitNotesListScreenRobot.goToAddNotePage();

    // Edit note screen
    final editNoteScreenRobot = EditNoteScreenRobot(tester);
    await editNoteScreenRobot.checkInitialState();
    await editNoteScreenRobot.fillFormAndSave();

    expect(find.text(editNoteScreenRobot.titleText), findsOneWidget);
    expect(find.text(editNoteScreenRobot.descriptionText), findsOneWidget);

    // Go to edit note and delete note
    await gitNotesListScreenRobot.goToEditNoteScreenWithTitle(
      editNoteScreenRobot.titleText,
    );

    await tester.pumpAndSettle();
    expect(find.byType(HomeTabbarPage), findsOneWidget);
    expect(find.byType(EditNotePage), findsOneWidget);

    await editNoteScreenRobot.deleteNote();

    // Check note deleted
    await gitNotesListScreenRobot.checkEmptyPageState();

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
    await enterPinRobot.fillFormAndLogin();

/********** */
    // final remoteConfigRobot = RemoteConfigRobot(tester);

    // await remoteConfigRobot.configureGit();

    // final setRemoteConfigRobot = GitRemoteConfigRobot(tester);

    // adjustDI();

    // await tester.pumpAndSettle();

    // expect(find.byType(GitConfigurationForm), findsOneWidget);

    // await setRemoteConfigRobot.fillRemoteStorageConfigurationForm();

    // await remoteConfigRobot.tapOnNextButtonGit();

    // final enterPinRobot = EnterPinRobot(tester);

    // await enterPinRobot.fillEnterPinForm();

    // expect(find.byType(HomeTabbarPage), findsOneWidget);
    // expect(find.byType(GitNotesListScreen), findsOneWidget);

    // await Future.delayed(const Duration(seconds: 1));

    // final notePageRobot = NotePageRobot(tester);

    // await notePageRobot.toAddNotePage();

    // expect(find.byType(HomeTabbarPage), findsOneWidget);
    // expect(find.byType(EditNotePage), findsOneWidget);

    // final addNoteRobot = AddNoteRobot(tester);

    // await addNoteRobot.fillAddNoteForm();

    // expect(find.byType(HomeTabbarPage), findsOneWidget);
    // expect(find.byType(GitNotesListScreen), findsOneWidget);
    // expect(find.text(addNoteRobot.titleText), findsOneWidget);
    // expect(find.text(addNoteRobot.descriptionText), findsOneWidget);

    // await notePageRobot.toEditNoteWithTextPage(addNoteRobot.titleText);

    // expect(find.byType(HomeTabbarPage), findsOneWidget);
    // expect(find.byType(EditNotePage), findsOneWidget);

    // await addNoteRobot.deleteNote();

    // expect(find.byType(HomeTabbarPage), findsOneWidget);
    // expect(find.byType(GitNotesListScreen), findsOneWidget);
    // expect(find.text(addNoteRobot.titleText), findsNothing);
    // expect(find.text(addNoteRobot.descriptionText), findsNothing);

    // await setRemoteConfigRobot.dropRemoteStorageConfigurationFromHomePage();

    // await remoteConfigRobot.ensureVisible();
    // expect(find.byType(PinPageEnterPinForm), findsNothing);
  });
}
