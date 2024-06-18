import 'dart:typed_data';

import 'package:pwd/common/domain/model/remote_configuration/local_storage_target.dart';

sealed class CreateRealmConfigParameters {
  const CreateRealmConfigParameters();
  bool get isReadOnly;
  LocalStorageTarget get target;

  const factory CreateRealmConfigParameters.cache({
    required LocalStorageTarget target,
  }) = CreateRealmConfigParametersCache._;

  factory CreateRealmConfigParameters.tmp({
    required LocalStorageTarget target,
    required Uint8List bytes,
  }) = CreateRealmConfigParametersTemp._;
}

final class CreateRealmConfigParametersCache
    extends CreateRealmConfigParameters {
  const CreateRealmConfigParametersCache._({required this.target});

  @override
  final LocalStorageTarget target;

  @override
  bool get isReadOnly => false;
}

final class CreateRealmConfigParametersTemp
    extends CreateRealmConfigParameters {
  @override
  final LocalStorageTarget target;

  final Uint8List bytes;

  CreateRealmConfigParametersTemp._({
    required this.target,
    required this.bytes,
  }) {
    assert(bytes.isNotEmpty);
  }

  @override
  bool get isReadOnly => true;
}
