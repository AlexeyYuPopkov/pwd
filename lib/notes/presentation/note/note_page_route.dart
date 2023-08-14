import 'package:pwd/notes/domain/model/note_item.dart';

abstract class NotePageRoute {
  const NotePageRoute();

  const factory NotePageRoute.onEdit({
    required NoteItem noteItem,
  }) = NotePageOnEdit;

  const factory NotePageRoute.onDetails({
    required NoteItem noteItem,
  }) = NotePageOnDetails;

  const factory NotePageRoute.shouldSync() = NotePageShouldSync;
}

class NotePageOnEdit extends NotePageRoute {
  final NoteItem noteItem;

  const NotePageOnEdit({
    required this.noteItem,
  });
}

class NotePageOnDetails extends NotePageRoute {
  final NoteItem noteItem;

  const NotePageOnDetails({
    required this.noteItem,
  });
}

class NotePageShouldSync extends NotePageRoute {
  const NotePageShouldSync();
}
