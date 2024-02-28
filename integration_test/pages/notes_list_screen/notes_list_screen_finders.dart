import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/notes/presentation/common/widgets/note_list_item_widget.dart';
import 'package:pwd/notes/presentation/notes_list/notes_list_screen.dart';
import 'package:pwd/notes/presentation/notes_list/notes_list_screen_test_helper.dart';

final class NotesListScreenFinders {
  final screen = find.byType(NotesListScreen);

  final addNoteButton = find.byKey(
    const Key(NotesListScreenTestHelper.addNoteButtonKey),
  );

  final noteItemRow = find.byType(NoteListItemWidget);
  final noteItemEditIcon = find.byKey(
    const Key(NoteListItemWidgetTestHelper.editIconKey),
  );
}
