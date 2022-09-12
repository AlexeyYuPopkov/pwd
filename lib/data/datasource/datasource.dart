import 'package:pwd/data/model/note_data.dart';
import 'package:pwd/data/model/note_item_data.dart';

abstract class Datasource {
  Stream<NoteData> get noteStream;

  Future<void> updateNote(NoteData note);

  Future<void> readNote();

  NoteItemData newNoteItem();
}
