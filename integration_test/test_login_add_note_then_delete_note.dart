import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/home/presentation/home_tabbar_page.dart';
import 'package:pwd/main.dart' as app;
import 'package:pwd/notes/presentation/edit_note/edit_note_page.dart';
import 'package:pwd/notes/presentation/note/note_page.dart';
import 'package:pwd/unauth/presentation/configuration_screen/enter_configuration_form.dart';
import 'package:pwd/unauth/presentation/pin_page/pin_page_enter_pin_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_login_add_note_then_delete_note/add_note_robot.dart';
import 'test_login_add_note_then_delete_note/note_page_robot.dart';
import 'test_login_add_note_then_delete_note/enter_pin_robot.dart';
import 'test_login_add_note_then_delete_note/mock_remote_storage_configuration_provider.dart';
import 'test_login_add_note_then_delete_note/set_remote_config_robot.dart';

void adjustDI() {
  SharedPreferences.setMockInitialValues({
    'AppConfigurationProvider.AppConfigurationKey':
        '{"pxyIp": "127.0.0.1", "pxyPort": "8888"}',
  });

  DiStorage.shared.remove<RemoteStorageConfigurationProvider>();

  DiStorage.shared.bind<RemoteStorageConfigurationProvider>(
      () => MockRemoteStorageConfigurationProvider(),
      module: null,
      lifeTime: const LifeTime.single());
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test Login and add note, then delete note', (tester) async {
    
    app.main();

    final setRemoteConfigRobot = SetRemoteConfigRobot(tester);

    adjustDI();

    await tester.pumpAndSettle();
    expect(find.byType(EnterConfigurationForm), findsOneWidget);

    await setRemoteConfigRobot.fillRemoteStorageConfigurationForm();

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

    expect(find.byType(EnterConfigurationForm), findsOneWidget);
    expect(find.byType(PinPageEnterPinForm), findsNothing);
  });
}
