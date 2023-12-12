part of 'remote_storage_settings_page_bloc.dart';

abstract class RemoteStorageSettingsPageState extends Equatable {
  final RemoteStorageConfiguration data;

  const RemoteStorageSettingsPageState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory RemoteStorageSettingsPageState.common(
      {required RemoteStorageConfiguration data}) = CommonState;

  const factory RemoteStorageSettingsPageState.loading(
      {required RemoteStorageConfiguration data}) = LoadingState;

  const factory RemoteStorageSettingsPageState.didLogout(
      {required RemoteStorageConfiguration data}) = DidLogoutState;

  const factory RemoteStorageSettingsPageState.error({
    required RemoteStorageConfiguration data,
    required Object error,
  }) = ErrorState;
}

class CommonState extends RemoteStorageSettingsPageState {
  const CommonState({required super.data});
}

class DidLogoutState extends RemoteStorageSettingsPageState {
  const DidLogoutState({required super.data});
}

class LoadingState extends RemoteStorageSettingsPageState {
  const LoadingState({required super.data});
}

class ErrorState extends RemoteStorageSettingsPageState {
  final Object error;
  const ErrorState({
    required super.data,
    required this.error,
  });
}
