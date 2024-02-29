import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

class DeleteNoteUsecase {
  final PinUsecase pinUsecase;
  final RealmLocalRepository localRepository;
  final SyncUsecase syncUsecase;

  const DeleteNoteUsecase({
    required this.pinUsecase,
    required this.localRepository,
    required this.syncUsecase,
  });

  Future<void> execute({
    required String id,
    required RemoteConfiguration configuration,
  }) async {
    final pin = pinUsecase.getPinOrThrow();
    await localRepository.markDeleted(
      id,
      target: configuration.getTarget(pin: pin),
    );
    await syncUsecase.execute(configuration: configuration);
  }
}
