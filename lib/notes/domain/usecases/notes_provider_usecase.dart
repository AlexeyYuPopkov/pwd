import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

abstract class NotesProviderUsecase {
  Stream<List<NoteItem>> get noteStream;

  Future<List<NoteItem>> readNotes({
    required RemoteConfiguration configuration,
  });

  Future<void> updateNoteItem(
    NoteItem noteItem, {
    required RemoteConfiguration configuration,
  });

  Future<void> deleteNoteItem(
    NoteItem noteItem, {
    required RemoteConfiguration configuration,
  });
}
