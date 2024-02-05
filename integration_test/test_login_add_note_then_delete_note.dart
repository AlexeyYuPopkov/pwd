import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_page.dart';
import 'package:pwd/main.dart' as app;
import 'package:pwd/notes/presentation/edit_note/edit_note_page.dart';
import 'package:pwd/notes/presentation/note/note_page.dart';
import 'package:pwd/unauth/presentation/configuration_screen/git_configuration_form.dart';
import 'package:pwd/unauth/presentation/pin_page/pin_page_enter_pin_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_login_add_note_then_delete_note/add_note_robot.dart';
import 'test_login_add_note_then_delete_note/enter_pin_robot.dart';
import 'test_login_add_note_then_delete_note/git_remote_config_robot.dart';

import 'test_login_add_note_then_delete_note/note_page_robot.dart';
import 'test_login_add_note_then_delete_note/remote_config_robot.dart';

void adjustDI() {
  SharedPreferences.setMockInitialValues({
    // 'AppConfigurationProvider.AppConfigurationKey':
    //     '{"pxyIp": "127.0.0.1", "pxyPort": "8888"}',
    'AppConfigurationProvider.AppConfigurationKey': '',
  });
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test Login and add note, then delete note', (tester) async {
    app.main();

    final RemoteStorageConfigurationProvider
        remoteStorageConfigurationProvider = DiStorage.shared.resolve();

    await remoteStorageConfigurationProvider.dropConfiguration();

    await tester.pumpAndSettle();
    final remoteConfigRobot = RemoteConfigRobot(tester);

    await remoteConfigRobot.configureGit();

    final setRemoteConfigRobot = GitRemoteConfigRobot(tester);

    adjustDI();

    await tester.pumpAndSettle();

    expect(find.byType(GitConfigurationForm), findsOneWidget);

    await setRemoteConfigRobot.fillRemoteStorageConfigurationForm();

    await remoteConfigRobot.tapOnNextButtonGit();

    final enterPinRobot = EnterPinRobot(tester);

    await enterPinRobot.fillEnterPinForm();

    expect(find.byType(HomeTabbarPage), findsOneWidget);
    expect(find.byType(NotePage), findsOneWidget);

    await Future.delayed(const Duration(seconds: 1));

    final notePageRobot = NotePageRobot(tester);

    await notePageRobot.toAddNotePage();

    expect(find.byType(HomeTabbarPage), findsOneWidget);
    expect(find.byType(EditNotePage), findsOneWidget);

    final addNoteRobot = AddNoteRobot(tester);

    await addNoteRobot.fillAddNoteForm();

    expect(find.byType(HomeTabbarPage), findsOneWidget);
    expect(find.byType(NotePage), findsOneWidget);
    expect(find.text(addNoteRobot.titleText), findsOneWidget);
    expect(find.text(addNoteRobot.descriptionText), findsOneWidget);

    await notePageRobot.toEditNoteWithTextPage(addNoteRobot.titleText);

    expect(find.byType(HomeTabbarPage), findsOneWidget);
    expect(find.byType(EditNotePage), findsOneWidget);

    await addNoteRobot.deleteNote();

    expect(find.byType(HomeTabbarPage), findsOneWidget);
    expect(find.byType(NotePage), findsOneWidget);
    expect(find.text(addNoteRobot.titleText), findsNothing);
    expect(find.text(addNoteRobot.descriptionText), findsNothing);

    await setRemoteConfigRobot.dropRemoteStorageConfigurationFromHomePage();

    await remoteConfigRobot.ensureVisible();
    expect(find.byType(PinPageEnterPinForm), findsNothing);
  });
}
