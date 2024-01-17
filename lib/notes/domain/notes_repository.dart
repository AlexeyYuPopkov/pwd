import 'package:pwd/notes/domain/model/note_item.dart';

abstract interface class NotesRepository {
  Future<int> updateNote(NoteItem noteItem);

  Future<int> delete(String id);

  Future<NoteItem?> readNote(String id);

  Future<List<NoteItem>> readNotes();

  Future<void> close();

  Future<void> updateDb({required String rawSql});

  Future<int> lastRecordTimestamp();

  Future<String> exportNotes();

  Future<int> importNotes({
    required Map<String, dynamic> jsonMap,
  });

  Future<void> dropDb();

  String createEmptyDbContent(int timestamp);
}
