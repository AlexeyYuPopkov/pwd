part of 'pin_page_bloc.dart';

abstract class PinPageBlocEvent extends Equatable {
  const PinPageBlocEvent();

  const factory PinPageBlocEvent.initial() = InitialEvent;

  const factory PinPageBlocEvent.setRemoteStorageConfiguration({
    required String token,
    required String repo,
    required String owner,
    required String branch,
    required String fileName,
    required bool needsCreateNewFile,
  }) = SetRemoteStorageConfigurationEvent;

  const factory PinPageBlocEvent.login({required String pin}) = LoginEvent;

  @override
  List<Object?> get props => const [];
}

class InitialEvent extends PinPageBlocEvent {
  const InitialEvent();
}

class SetRemoteStorageConfigurationEvent extends PinPageBlocEvent {
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

class LoginEvent extends PinPageBlocEvent {
  final String pin;
  const LoginEvent({required this.pin});
}
