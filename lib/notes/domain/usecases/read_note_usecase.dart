import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/model/db_error.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

class ReadNoteUsecase {
  final RemoteConfigurationProvider _remoteConfigurationProvider;
  final RealmLocalRepository _repository;
  final PinUsecase _pinUsecase;

  const ReadNoteUsecase({
    required RemoteConfigurationProvider remoteConfigurationProvider,
    required RealmLocalRepository repository,
    required PinUsecase pinUsecase,
  })  : _remoteConfigurationProvider = remoteConfigurationProvider,
        _repository = repository,
        _pinUsecase = pinUsecase;

  Future<NoteItem> execute({
    required String configId,
    required String noteId,
  }) async {
    if (noteId.isEmpty) {
      throw const DbError.notFound();
    }

    final configuration =
        _remoteConfigurationProvider.currentConfiguration.withId(configId);

    if (configuration == null || configuration.id.isEmpty) {
      throw const DbError.notFound();
    }

    final pin = _pinUsecase.getPinOrThrow();

    final result = await _repository.readNote(
      noteId,
      target: configuration.getTarget(pin: pin),
    );

    if (result == null) {
      throw const DbError.notFound();
    }

    return result;
  }
}
