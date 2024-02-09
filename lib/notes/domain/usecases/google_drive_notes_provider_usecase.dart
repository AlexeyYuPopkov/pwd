import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/deleted_items_provider.dart';
import 'package:pwd/notes/domain/local_repository.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

final class GoogleDriveNotesProviderUsecase implements NotesProviderUsecase {
  final LocalRepository repository;
  final PinUsecase pinUsecase;
  final ChecksumChecker checksumChecker;
  final DeletedItemsProvider deletedItemsProvider;

  GoogleDriveNotesProviderUsecase({
    required this.repository,
    required this.pinUsecase,
    required this.checksumChecker,
    required this.deletedItemsProvider,
  });

  late final _noteStream = BehaviorSubject<List<NoteItem>>();

  @override
  Stream<List<NoteItem>> get noteStream => _noteStream;

  @override
  Future<List<NoteItem>> readNotes() async {
    try {
      final pin = pinUsecase.getPinOrThrow();
      final notes = await repository.readNotes(key: pin.pinSha512);
      _noteStream.add(notes);

      return notes;
    } catch (e) {
      throw NotesProviderError(parentError: e);
    }
  }

  @override
  Future<void> updateNoteItem(NoteItem noteItem) async {
    try {
      final pin = pinUsecase.getPinOrThrow();
      await repository.updateNote(noteItem, key: pin.pinSha512);
      await checksumChecker.dropChecksum();
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
        await Future.wait(
          [
            repository.delete(id, key: pin.pinSha512),
            deletedItemsProvider.addDeletedItems({id}),
            checksumChecker.dropChecksum(),
          ],
        );

        await readNotes();
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
