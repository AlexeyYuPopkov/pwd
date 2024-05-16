part of 'remote_configuration.dart';

final class GitConfiguration extends RemoteConfiguration {
  static const defaultBranch = 'main';
  @override
  final type = ConfigurationType.git;

  final String token;
  final String repo;
  final String owner;
  String get branch =>
      _branch?.trim().isNotEmpty == true ? _branch! : defaultBranch;
  @override
  final String fileName;
  final String? _branch;

  const GitConfiguration({
    required this.token,
    required this.repo,
    required this.owner,
    required String? branch,
    required this.fileName,
  }) : _branch = branch;

  @override
  List<Object?> get props => [
        token,
        repo,
        owner,
        branch,
        fileName,
        cacheTmpFileName,
      ];
}
