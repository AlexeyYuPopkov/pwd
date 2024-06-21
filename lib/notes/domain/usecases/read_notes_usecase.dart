import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

class ReadNotesUsecase {
  final RealmLocalRepository repository;
  final PinUsecase pinUsecase;
  final ChecksumChecker checksumChecker;

  const ReadNotesUsecase({
    required this.repository,
    required this.pinUsecase,
    required this.checksumChecker,
  });

  Future<List<NoteItem>> execute({
    required RemoteConfiguration configuration,
  }) async {
    final pin = pinUsecase.getPinOrThrow();
    final notes = await repository.readNotes(
      target: configuration.getTarget(pin: pin),
    );

    return notes;
  }

  Stream<RealmLocalRepositoryNotification?> getChangesStream() =>
      repository.getChangesStream();
}
