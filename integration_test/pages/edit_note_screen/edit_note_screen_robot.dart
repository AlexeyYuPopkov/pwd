import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';

import 'edit_note_screen_finders.dart';

final class EditNoteScreenRobot {
  late final _finders = EditNoteScreenFinders();

  String get titleText => 'Title Test';
  String get descriptionText => 'Description Test';
  String get contentText => 'Content Test';

  Future<void> checkInitialState(WidgetTester tester) async {
    await tester.pumpAndSettle();

    await Future.wait([
      tester.ensureVisible(_finders.titleTextField),
      tester.ensureVisible(_finders.subtitleTextField),
      tester.ensureVisible(_finders.contentTextField),
      tester.ensureVisible(_finders.deleteButton),
      tester.ensureVisible(_finders.saveButton),
    ]);

    expect(_finders.titleTextField, findsOneWidget);
    expect(_finders.subtitleTextField, findsOneWidget);
    expect(_finders.contentTextField, findsOneWidget);
    expect(_finders.deleteButton, findsOneWidget);
    expect(_finders.saveButton, findsOneWidget);

    expect(
      tester.widget<OutlinedButton>(_finders.saveButton).enabled,
      false,
    );

// TODO: uncomment
    // expect(
    //   tester.widget<OutlinedButton>(_finders.deleteButton).enabled,
    //   false,
    // );
  }

  Future<void> fillFormAndSave(WidgetTester tester) async {
    await tester.tap(_finders.titleTextField);
    await tester.enterText(_finders.titleTextField, titleText);

    await tester.tap(_finders.subtitleTextField);
    await tester.enterText(_finders.subtitleTextField, descriptionText);

    await tester.tap(_finders.contentTextField);
    await tester.enterText(_finders.contentTextField, contentText);

    await tester.tap(_finders.saveButton);
  }

  Future<void> deleteNote(WidgetTester tester) async {
    await tester.pumpAndSettle();

    await tester.ensureVisible(_finders.deleteButton);
    await tester.tap(_finders.deleteButton);

    await tester.pumpAndSettle();

    final dialogOkButton = find.byKey(
      const Key(DialogHelperTestHelper.okCancelDialogOkButton),
    );

    await tester.ensureVisible(dialogOkButton);

    await tester.tap(dialogOkButton);

    await tester.pumpAndSettle(Durations.extralong4);
  }
}
