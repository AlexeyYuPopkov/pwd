import 'package:pwd/notes/domain/model/note.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

class NoteImpl extends Note {
  @override
  final String id;

  @override
  final List<NoteItem> notes;

  const NoteImpl({required this.id, required this.notes});
}
