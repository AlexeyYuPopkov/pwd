import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

class UpdateNoteUsecase {
  final RealmLocalRepository repository;
  final PinUsecase pinUsecase;
  final ChecksumChecker checksumChecker;
  final SyncUsecase syncUsecase;

  const UpdateNoteUsecase({
    required this.repository,
    required this.pinUsecase,
    required this.checksumChecker,
    required this.syncUsecase,
  });

  Future<void> execute(
    BaseNoteItem noteItem, {
    required RemoteConfiguration configuration,
  }) async {
    final pin = pinUsecase.getPinOrThrow();

    switch (noteItem) {
      case NoteItem():
        assert(false, 'Impossible case');
        return;
      case UpdatedNoteItem():
        await repository.updateNote(
          noteItem,
          target: configuration.getTarget(pin: pin),
        );
        break;
      case NewNoteItem():
        await repository.createNote(
          noteItem,
          target: configuration.getTarget(pin: pin),
        );
        break;
    }

    await checksumChecker.dropChecksum(
      configuration: configuration,
    );

    await syncUsecase.execute(configuration: configuration, force: false);
  }
}
