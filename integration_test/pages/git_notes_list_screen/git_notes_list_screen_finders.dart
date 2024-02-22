import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/notes/presentation/common/widgets/note_list_item_widget.dart';
import 'package:pwd/notes/presentation/git_notes_list/git_notes_list_screen.dart';
import 'package:pwd/notes/presentation/git_notes_list/git_notes_list_screen_test_helper.dart';

final class GitNotesListScreenFinders {
  final screen = find.byType(GitNotesListScreen);

  final addNoteButton = find.byKey(
    const Key(GitNotesListScreenTestHelper.addNoteButtonKey),
  );

  final noteItemRow = find.byType(NoteListItemWidget);
  final noteItemEditIcon = find.byKey(
    const Key(NoteListItemWidgetTestHelper.editIconKey),
  );
}
