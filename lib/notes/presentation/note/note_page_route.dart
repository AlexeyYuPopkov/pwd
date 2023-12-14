import 'package:pwd/notes/domain/model/note_item.dart';

sealed class NotePageRoute {
  const NotePageRoute();

  const factory NotePageRoute.onEdit({
    required NoteItem noteItem,
  }) = NotePageOnEdit;

  const factory NotePageRoute.onDetails({
    required NoteItem noteItem,
  }) = NotePageOnDetails;

  const factory NotePageRoute.shouldSync() = NotePageShouldSync;
}

final class NotePageOnEdit extends NotePageRoute {
  final NoteItem noteItem;

  const NotePageOnEdit({
    required this.noteItem,
  });
}

final class NotePageOnDetails extends NotePageRoute {
  final NoteItem noteItem;

  const NotePageOnDetails({
    required this.noteItem,
  });
}

final class NotePageShouldSync extends NotePageRoute {
  const NotePageShouldSync();
}
