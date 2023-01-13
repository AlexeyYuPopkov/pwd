import 'package:pwd/notes/domain/model/note_item.dart';

abstract class NotesProviderRepository {
  Stream<List<NoteItem>> get noteStream;

  Future<void> readNotes();

  Future<void> updateNoteItem(NoteItem noteItem);
}
