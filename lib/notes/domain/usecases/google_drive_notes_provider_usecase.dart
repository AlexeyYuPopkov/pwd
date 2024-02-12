import 'package:rxdart/rxdart.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/deleted_items_provider.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

final class GoogleDriveNotesProviderUsecase implements NotesProviderUsecase {
  final RealmLocalRepository repository;
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
    final pin = pinUsecase.getPinOrThrow();
    final notes = await repository.readNotes(key: pin.pinSha512);
    _noteStream.add(notes);

    return notes;
  }

  @override
  Future<void> updateNoteItem(NoteItem noteItem) async {
    final pin = pinUsecase.getPinOrThrow();
    await repository.updateNote(noteItem, key: pin.pinSha512);
    await checksumChecker.dropChecksum();
    readNotes();
  }

  @override
  Future<void> deleteNoteItem(NoteItem noteItem) async {
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
  }
}
