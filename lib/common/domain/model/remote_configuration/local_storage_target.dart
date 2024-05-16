import 'package:equatable/equatable.dart';

import 'remote_configuration.dart';

final class LocalStorageTarget extends Equatable implements CacheTarget {
  final List<int> key;
  @override
  final String fileName;
  @override
  final String cacheTmpFileName;

  const LocalStorageTarget({
    required this.key,
    required this.fileName,
    required this.cacheTmpFileName,
  });

  @override
  List<Object?> get props => [
        key,
        fileName,
        fileName,
      ];
}
