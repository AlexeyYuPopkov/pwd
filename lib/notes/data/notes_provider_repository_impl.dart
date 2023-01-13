import 'package:rxdart/rxdart.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/notes_provider_repository.dart';
import 'package:pwd/notes/domain/notes_repository.dart';

class NotesProviderRepositoryImpl implements NotesProviderRepository {
  final NotesRepository repository;

  NotesProviderRepositoryImpl({required this.repository});

  @override
  Stream<List<NoteItem>> get noteStream => _noteStream;

  late final _noteStream = BehaviorSubject<List<NoteItem>>();

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
