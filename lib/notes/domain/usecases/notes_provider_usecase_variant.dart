import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/local_repository.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

abstract class NotesProviderUsecaseVariant extends NotesProviderUsecase {}

class NotesProviderUsecaseVariantImpl implements NotesProviderUsecaseVariant {
  final LocalRepository repository;
  final PinUsecase pinUsecase;

  NotesProviderUsecaseVariantImpl({
    required this.repository,
    required this.pinUsecase,
  });

  late final _noteStream = BehaviorSubject<List<NoteItem>>();

  @override
  Stream<List<NoteItem>> get noteStream => _noteStream;

  @override
  List<NoteItem> get notes => _noteStream.value;

  @override
  Future<void> readNotes() async {
    try {
      final pin = pinUsecase.getPinOrThrow();
      final notes = await repository.readNotes(key: pin.pinSha512);
      _noteStream.add(notes);
    } catch (e) {
      throw NotesProviderError(parentError: e);
    }
  }

  @override
  Future<void> updateNoteItem(NoteItem noteItem) async {
    try {
      final pin = pinUsecase.getPinOrThrow();
      await repository.updateNote(noteItem, key: pin.pinSha512);
      readNotes();
    } catch (e) {
      throw NotesProviderError(parentError: e);
    }
  }

  @override
  Future<void> deleteNoteItem(NoteItem noteItem) async {
    try {
      final pin = pinUsecase.getPinOrThrow();
      final id = noteItem.id;
      if (id.isNotEmpty) {
        await repository.delete(id, key: pin.pinSha512);
        readNotes();
      }
    } catch (e) {
      throw NotesProviderError(parentError: e);
    }
  }
}

// Errors
final class NotesProviderError extends AppError {
  const NotesProviderError({
    super.parentError,
  }) : super(message: '');
}
