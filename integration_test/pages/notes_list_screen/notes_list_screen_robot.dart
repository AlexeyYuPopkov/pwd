import 'package:flutter_test/flutter_test.dart';

import 'notes_list_screen_finders.dart';

final class NotesListScreenRobot {
  NotesListScreenRobot(this.tester);
  final WidgetTester tester;

  late final _finders = NotesListScreenFinders();

  Future<void> checkEmptyPageState() async {
    await tester.pumpAndSettle();

    await Future.wait([
      tester.ensureVisible(_finders.screen),
      tester.ensureVisible(_finders.addNoteButton),
    ]);

    expect(_finders.screen, findsOneWidget);
    expect(_finders.addNoteButton, findsOneWidget);

    expect(_finders.noteItemRow, findsNothing);
  }

  Future<void> goToAddNotePage() async {
    await tester.pumpAndSettle();

    await tester.tap(_finders.addNoteButton);
  }

  Future<void> goToEditNoteScreenWithTitle(String noteTitle) async {
    await tester.pumpAndSettle();

    // TODO: remove first
    final title = find.text(noteTitle).first;

    final cell = find.ancestor(
      of: title,
      matching: _finders.noteItemRow,
    );

    final icon = find.descendant(
      of: cell,
      matching: _finders.noteItemEditIcon,
    );

    expect(icon, findsOneWidget);
    await tester.tap(icon);
  }
}
