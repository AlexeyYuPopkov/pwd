import 'package:pwd/notes/data/model/note_item_data.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

abstract class NotesRepository {
  Future<int> insertNote(NoteItem noteItem);

  Future<int> updatetNote(NoteItem noteItem);

  Future<int> delete(int id);

  Future<NoteItem?> readNote(int id);

  Future<List<NoteItem>> readNotes();

  Future<void> close();

  Future<void> updateDb({required String rawSql});

  Future<List<NoteItemData>> exportNotes();

  Future<void> importNotes(List<NoteItemData> notes);
}
