import 'package:equatable/equatable.dart';

sealed class ConfigurationScreenEvent extends Equatable {
  const ConfigurationScreenEvent();

  const factory ConfigurationScreenEvent.initial() = InitialEvent;

  const factory ConfigurationScreenEvent.setRemoteStorageConfiguration({
    required String token,
    required String repo,
    required String owner,
    required String branch,
    required String fileName,
    required bool needsCreateNewFile,
  }) = SetRemoteStorageConfigurationEvent;

  @override
  List<Object?> get props => const [];
}

class InitialEvent extends ConfigurationScreenEvent {
  const InitialEvent();
}

final class SetRemoteStorageConfigurationEvent
    extends ConfigurationScreenEvent {
  final String token;
  final String repo;
  final String owner;
  final String branch;
  final String fileName;
  final bool needsCreateNewFile;

  const SetRemoteStorageConfigurationEvent({
    required this.token,
    required this.repo,
    required this.owner,
    required this.branch,
    required this.fileName,
    required this.needsCreateNewFile,
  });
}
