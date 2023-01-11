import 'package:rxdart/rxdart.dart';
import 'package:pwd/notes/domain/notes_repository.dart';

import 'model/note_item.dart';

abstract class NotesProvider {
  Stream<List<NoteItem>> get noteStream;

  Future<void> readNotes();

  Future<void> updateNoteItem(NoteItem noteItem);

}

class NotesProviderImpl implements NotesProvider {
  final NotesRepository repository;

  NotesProviderImpl({required this.repository});

  @override
  Stream<List<NoteItem>> get noteStream {
    return _noteStream; //.shareReplay(maxSize: 1);
  }

  late final PublishSubject<List<NoteItem>> _noteStream =
      PublishSubject<List<NoteItem>>(
    // NoteData.empty(),
    onListen: () => readNotes(),
  );

  @override
  Future<void> readNotes() async {
    final notes = await repository.readNotes();
    _noteStream.add(notes);
  }

  @override
  Future<void> updateNoteItem(NoteItem noteItem) async {
    await repository.updatetNote(noteItem);
    readNotes();
  }


}
