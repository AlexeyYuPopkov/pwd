import 'package:equatable/equatable.dart';

import 'remote_configuration.dart';

final class LocalStorageTarget extends Equatable implements CacheTerget {
  final List<int> key;
  @override
  final String cacheFileName;
  @override
  final String cacheTmpFileName;

  const LocalStorageTarget({
    required this.key,
    required this.cacheFileName,
    required this.cacheTmpFileName,
  });

  @override
  List<Object?> get props => [
        key,
        cacheFileName,
        cacheFileName,
      ];
}
