import 'package:pwd/data/datasource/datasource.dart';
import 'package:pwd/data/model/note_data.dart';
import 'package:pwd/data/model/note_item_data.dart';
import 'package:pwd/domain/gateway.dart';
import 'package:pwd/domain/model/note.dart';

class GatewayImpl implements Gateway {
  final Datasource datasource;

  GatewayImpl({
    required this.datasource,
  });

  @override
  Stream<Note> get noteStream => datasource.noteStream;

  @override
  Future<void> readNote() => datasource.readNote();

  @override
  Future<void> updateNote(Note note) => datasource.updateNote(note as NoteData);

  @override
  NoteItemData newNoteItem() => datasource.newNoteItem();
}
