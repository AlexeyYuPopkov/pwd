import 'package:pwd/notes/domain/model/note_item.dart';

abstract interface class LocalRepository {
  Future<void> saveNotes({required List<NoteItem> notes});
}
