import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_test/flutter_test.dart';

class AddNoteRobot {
  const AddNoteRobot(this.tester);
  final WidgetTester tester;

  Future<void> fillAddNoteForm() async {
    await tester.pumpAndSettle();

    final titleField = find.byKey(const Key('test_edit_note_title_key'));
    final descriptionField =
        find.byKey(const Key('test_edit_note_description_key'));
    final contentField = find.byKey(const Key('test_edit_note_content_key'));
    final saveButton = find.byKey(const Key('test_edit_note_save_button_key'));

    await Future.wait([
      tester.ensureVisible(titleField),
      tester.ensureVisible(descriptionField),
      tester.ensureVisible(contentField),
      tester.ensureVisible(saveButton),
    ]);

    expect(titleField, findsOneWidget);
    expect(descriptionField, findsOneWidget);
    expect(contentField, findsOneWidget);
    expect(saveButton, findsOneWidget);

    await tester.tap(titleField);
    await tester.enterText(titleField, titleText);

    await tester.tap(descriptionField);
    await tester.enterText(descriptionField, descriptionText);

    await tester.tap(contentField);
    await tester.enterText(contentField, contentText);

    await tester.tap(saveButton);

    await tester.pumpAndSettle();
  }

  Future<void> deleteNote() async {
    await tester.pumpAndSettle();

    final deleteButton = find.byKey(
      const Key('test_edit_note_delete_button_key'),
    );

    await tester.ensureVisible(deleteButton);

    await tester.tap(deleteButton);

    await tester.pumpAndSettle();

    final dialogOkButton = find.byKey(
      const Key('test_ok_cancel_dialog_ok_button'),
    );

    await tester.ensureVisible(dialogOkButton);

    await tester.tap(dialogOkButton);

    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 2));

    await tester.pumpAndSettle();
  }

  String get titleText => 'Title Test';
  String get descriptionText => 'Description Test';
  String get contentText => 'Content Test';
}
