import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/model/db_error.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

class UpdateNoteUsecase {
  final RemoteConfigurationProvider _configProvider;
  final RealmLocalRepository _repository;
  final PinUsecase _pinUsecase;
  final ChecksumChecker _checksumChecker;
  final SyncUsecase _syncUsecase;

  const UpdateNoteUsecase({
    required RemoteConfigurationProvider remoteConfigurationProvider,
    required RealmLocalRepository repository,
    required PinUsecase pinUsecase,
    required ChecksumChecker checksumChecker,
    required SyncUsecase syncUsecase,
  })  : _configProvider = remoteConfigurationProvider,
        _repository = repository,
        _pinUsecase = pinUsecase,
        _checksumChecker = checksumChecker,
        _syncUsecase = syncUsecase;

  Future<void> execute(
    BaseNoteItem noteItem, {
    required String configurationId,
  }) async {
    final pin = _pinUsecase.getPinOrThrow();

    final configuration = _configProvider.currentConfiguration.withId(
      configurationId,
    );

    if (configuration == null || configuration.id.isEmpty) {
      throw const DbError.notFound();
    }

    switch (noteItem) {
      case NoteItem():
        await _repository.updateNote(
          noteItem,
          target: configuration.getTarget(pin: pin),
        );
        break;
      case NewNoteItem():
        await _repository.createNote(
          noteItem,
          target: configuration.getTarget(pin: pin),
        );
        break;
    }

    await _checksumChecker.dropChecksum(
      configuration: configuration,
    );

    await _syncUsecase.execute(configuration: configuration, force: false);
  }
}
