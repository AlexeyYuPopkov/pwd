import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pwd/notes/domain/notes_repository.dart';

import '../model/note_item.dart';

abstract class NotesProviderUsecase {
  Stream<List<NoteItem>> get noteStream;

  Future<void> readNotes();

  Future<void> updateNoteItem(NoteItem noteItem);
}

class NotesProviderUsecaseImpl implements NotesProviderUsecase {
  final NotesRepository repository;

  NotesProviderUsecaseImpl({required this.repository});

  @override
  Stream<List<NoteItem>> get noteStream {
    return _noteStream; //.shareReplay(maxSize: 1);
  }

  late final PublishSubject<List<NoteItem>> _noteStream =
      PublishSubject<List<NoteItem>>(
    // NoteData.empty(),
    onListen: () => readNotes(),
  )..shareReplay(maxSize: 1).asBroadcastStream();

  @override
  Future<void> readNotes() async {
    try {
      final notes = await repository.readNotes();
      _noteStream.add(notes);
    } catch (e) {
      throw NotesProviderError.read(parentError: e);
    }
  }

  @override
  Future<void> updateNoteItem(NoteItem noteItem) async {
    try {
      await repository.updateNote(noteItem);
      readNotes();
    } catch (e) {
      throw NotesProviderError.updatet(parentError: e);
    }
  }
}

abstract class NotesProviderError extends AppError {
  const NotesProviderError({
    required super.message,
    super.parentError,
  });

  factory NotesProviderError.read({required Object? parentError}) =
      ReadNotesError;

  factory NotesProviderError.updatet({required Object? parentError}) =
      UpdatetNoteError;
}

class ReadNotesError extends NotesProviderError {
  const ReadNotesError({required super.parentError}) : super(message: '');
}

class UpdatetNoteError extends NotesProviderError {
  const UpdatetNoteError({required super.parentError}) : super(message: '');
}
