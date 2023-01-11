import 'package:pwd/notes/domain/model/note_item.dart';

abstract class NotesRepository {
  Future<int> insertNote(NoteItem noteItem);

  Future<int> updatetNote(NoteItem noteItem);

  Future<int> delete(int id);

  Future<NoteItem?> readNote(int id);

  Future<List<NoteItem>> readNotes();

  Future<void> close();
}

