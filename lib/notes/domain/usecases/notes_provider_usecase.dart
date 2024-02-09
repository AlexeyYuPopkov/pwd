import 'package:pwd/notes/domain/model/note_item.dart';

abstract class NotesProviderUsecase {
  Stream<List<NoteItem>> get noteStream;

  Future<List<NoteItem>> readNotes();

  Future<void> updateNoteItem(NoteItem noteItem);

  Future<void> deleteNoteItem(NoteItem noteItem);
}
