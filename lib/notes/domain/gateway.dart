import 'package:pwd/notes/domain/model/note.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

abstract class Gateway {
  Stream<Note> noteStream();

  Future<void> updateNote(Note note);

  Future<void> readNote();

  NoteItem newNoteItem();
}
