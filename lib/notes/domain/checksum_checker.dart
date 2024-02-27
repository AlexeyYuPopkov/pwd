import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

abstract interface class ChecksumChecker {
  Future<String?> getChecksum({required RemoteConfiguration configuration});

  Future<void> setChecksum(
    String checksum, {
    required RemoteConfiguration configuration,
  });

  Future<void> dropChecksum({
    required RemoteConfiguration configuration,
  });
}
