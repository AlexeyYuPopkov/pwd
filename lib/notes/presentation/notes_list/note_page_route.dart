import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

sealed class NotePageRoute {
  const NotePageRoute();

  const factory NotePageRoute.onUpdate({
    required String configId,
    required String noteId,
  }) = NotePageOnUpdate;

  const factory NotePageRoute.onCreate({
    required String configId,
  }) = NotePageOnCreate;

  const factory NotePageRoute.onDetails({
    required RemoteConfiguration config,
    required NoteItem noteItem,
  }) = NotePageOnDetails;

  const factory NotePageRoute.shouldSync() = NotePageShouldSync;
}

final class NotePageOnUpdate extends NotePageRoute {
  final String configId;
  final String noteId;

  const NotePageOnUpdate({
    required this.configId,
    required this.noteId,
  });
}

final class NotePageOnCreate extends NotePageRoute {
  final String configId;

  const NotePageOnCreate({
    required this.configId,
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
