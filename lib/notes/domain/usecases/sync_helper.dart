import 'dart:typed_data';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';

mixin SyncHelper {
  RealmLocalRepository get realmRepository;
  PinUsecase get pinUsecase;

  Future<Uint8List> getLocalRealmAsData({
    required RemoteConfiguration configuration,
  }) async {
    final pin = pinUsecase.getPinOrThrow();
    return realmRepository.readAsBytes(
      target: configuration.getTarget(pin: pin),
    );
  }
}
