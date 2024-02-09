import 'package:pwd/common/domain/model/remote_storage_configuration.dart';

abstract interface class SyncUsecase {
  Future<void> sync({required RemoteStorageConfiguration configuration});
  Future<void> updateRemote(
      {required RemoteStorageConfiguration configuration});
}
