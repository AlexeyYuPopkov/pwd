import 'package:pwd/notes/domain/model/note_item.dart';

abstract class MainRouteData {
  const MainRouteData();
  const factory MainRouteData.onEdit({
    required NoteItem noteItem,
  }) = OnNoteEdit;
}

class OnNoteEdit extends MainRouteData {
  final NoteItem noteItem;

  const OnNoteEdit({
    required this.noteItem,
  });
}
