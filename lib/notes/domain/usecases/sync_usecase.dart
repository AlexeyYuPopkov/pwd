import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

abstract interface class SyncUsecase {
  Future<void> sync({required RemoteConfiguration configuration});
  Future<void> updateRemote({
    required RemoteConfiguration configuration,
  });
}
