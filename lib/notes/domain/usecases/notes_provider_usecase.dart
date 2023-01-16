import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/notes_repository.dart';

abstract class NotesProviderUsecase {
  Stream<List<NoteItem>> get noteStream;

  Future<void> readNotes();

  Future<void> updateNoteItem(NoteItem noteItem);
}

class NotesProviderUsecaseImpl implements NotesProviderUsecase {
  final NotesRepository repository;
  final HashUsecase hashUsecase;

  NotesProviderUsecaseImpl({
    required this.repository,
    required this.hashUsecase,
  });

  late final _noteStream = BehaviorSubject<List<NoteItem>>();

  @override
  Stream<List<NoteItem>> get noteStream => _noteStream.map(
        (items) {
          NoteItem decryptedOrRaw(NoteItem item) {
            final title = hashUsecase.tryDecode(item.title);
            final description = hashUsecase.tryDecode(item.description);
            final content = hashUsecase.tryDecode(item.content);

            if (title == null || description == null || content == null) {
              return item;
            } else {
              return NoteItem.decrypted(
                id: item.id,
                title: title,
                description: description,
                content: content,
                timestamp: item.timestamp,
              );
            }
          }

          return [
            for (final item in items) decryptedOrRaw(item),
          ];
        },
      );

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
      final encoded = NoteItem.updatedItem(
        id: noteItem.id,
        title: hashUsecase.encode(noteItem.title),
        description: hashUsecase.encode(noteItem.description),
        content: hashUsecase.encode(noteItem.content),
      );
      await repository.updateNote(encoded);
      readNotes();
    } catch (e) {
      throw NotesProviderError.updated(parentError: e);
    }
  }
}

// Errors
abstract class NotesProviderError extends AppError {
  const NotesProviderError({
    required super.message,
    super.parentError,
  });

  factory NotesProviderError.read({required Object? parentError}) =
      ReadNotesError;

  factory NotesProviderError.updated({required Object? parentError}) =
      UpdatetNoteError;
}

class ReadNotesError extends NotesProviderError {
  const ReadNotesError({required super.parentError}) : super(message: '');
}

class UpdatetNoteError extends NotesProviderError {
  const UpdatetNoteError({required super.parentError}) : super(message: '');
}
