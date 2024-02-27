import 'package:equatable/equatable.dart';

final class LocalStorageTarget extends Equatable {
  final List<int> key;
  final String cacheFileName;
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
