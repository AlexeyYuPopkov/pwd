import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/notes/presentation/note/note_page.dart';

class NotePageRobot {
  const NotePageRobot(this.tester);
  final WidgetTester tester;

  Future<void> toAddNotePage() async {
    await tester.pumpAndSettle();

    final notePage = find.byType(NotePage);

    await tester.ensureVisible(notePage);

    final testAddNoteButton = find.byKey(const Key('test_add_note_button'));

    await tester.ensureVisible(testAddNoteButton);

    expect(testAddNoteButton, findsOneWidget);

    await tester.tap(testAddNoteButton);
    await tester.pumpAndSettle();
  }

  Future<void> toEditNoteWithTextPage(String noteTitle) async {

    final title = find.text(noteTitle);

    final cell = find.ancestor(
      of: title,
      matching: find.byType(NoteListItemWidget),
    );

    final icon = find.descendant(
      of: cell,
      matching: find.byType(CupertinoButton),
    );

    expect(icon, findsOneWidget);
    await tester.tap(icon);
    await tester.pumpAndSettle();
  }
}