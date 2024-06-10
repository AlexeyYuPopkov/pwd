import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

sealed class NotePageRoute {
  const NotePageRoute();

  const factory NotePageRoute.onEdit({
    required RemoteConfiguration config,
    required BaseNoteItem noteItem,
  }) = NotePageOnEdit;

  const factory NotePageRoute.onDetails({
    required RemoteConfiguration config,
    required NoteItem noteItem,
  }) = NotePageOnDetails;

  const factory NotePageRoute.shouldSync() = NotePageShouldSync;
}

final class NotePageOnEdit extends NotePageRoute {
  final RemoteConfiguration config;
  final BaseNoteItem noteItem;

  const NotePageOnEdit({
    required this.config,
    required this.noteItem,
  });
}

final class NotePageOnDetails extends NotePageRoute {
  final RemoteConfiguration config;
  final BaseNoteItem noteItem;

  const NotePageOnDetails({
    required this.config,
    required this.noteItem,
  });
}

final class NotePageShouldSync extends NotePageRoute {
  const NotePageShouldSync();
}
