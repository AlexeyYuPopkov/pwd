import 'package:pwd/domain/model/note.dart';
import 'package:pwd/domain/model/note_item.dart';

abstract class Gateway {
  Stream<Note> get noteStream;

  Future<void> updateNote(Note note);

  Future<void> readNote();

  NoteItem newNoteItem();
}
