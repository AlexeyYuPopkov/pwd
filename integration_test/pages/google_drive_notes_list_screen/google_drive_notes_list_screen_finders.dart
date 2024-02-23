import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/notes/presentation/common/widgets/note_list_item_widget.dart';
import 'package:pwd/notes/presentation/google_drive_notes_list/google_drive_notes_list_screen.dart';
import 'package:pwd/notes/presentation/google_drive_notes_list/google_drive_notes_list_screen_test_helper.dart';

final class GoogleDriveNotesListScreenFinders {
  final screen = find.byType(GoogleDriveNotesListScreen);

  final addNoteButton = find.byKey(
    const Key(GoogleDriveNotesListScreenTestHelper.addNoteButtonKey),
  );

  final noteItemRow = find.byType(NoteListItemWidget);
  final noteItemEditIcon = find.byKey(
    const Key(NoteListItemWidgetTestHelper.editIconKey),
  );
}
