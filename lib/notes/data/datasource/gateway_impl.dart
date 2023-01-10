import 'package:pwd/notes/data/datasource/datasource.dart';
import 'package:pwd/notes/data/model/note_data.dart';
import 'package:pwd/notes/data/model/note_item_data.dart';
import 'package:pwd/notes/domain/gateway.dart';
import 'package:pwd/notes/domain/model/note.dart';

class GatewayImpl implements Gateway {
  final Datasource datasource;

  GatewayImpl({
    required this.datasource,
  });

  @override
  Stream<Note> noteStream() => datasource.noteStream;

  @override
  Future<void> readNote() => datasource.readNote();

  @override
  Future<void> updateNote(Note note) => datasource.updateNote(
        NoteData(
          id: note.id,
          notes: note.notes
              .map(
                (src) => NoteItemData(
                  id: src.id,
                  title: NoteItemValueData(
                    style: src.title.style,
                    text: src.title.text,
                  ),
                  description: NoteItemValueData(
                    style: src.description.style,
                    text: src.description.text,
                  ),
                  content: NoteItemValueData(
                    style: src.content.style,
                    text: src.content.text,
                  ),
                  date: src.date,
                ),
              )
              .toList(),
        ),
      );

  @override
  NoteItemData newNoteItem() => datasource.newNoteItem();
}
