import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_screen.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_screen_test_helper.dart';

final class EditNoteScreenFinders {
  final screen = find.byType(EditNoteScreen);

  final blocConsumer = find.byKey(
    const Key(EditNoteScreenTestHelper.blocConsumerKey),
  );

  final saveButton = find.byKey(
    const Key(EditNoteScreenTestHelper.saveButtonKey),
  );
  final deleteButton = find.byKey(
    const Key(EditNoteScreenTestHelper.deleteButtonKey),
  );

  final contentTextField = find.byKey(
    const Key(EditNoteScreenTestHelper.contentTextFieldKey),
  );
}
