part of 'remote_storage_settings_page_bloc.dart';

sealed class RemoteStorageSettingsPageState extends Equatable {
  final RemoteStorageConfigurations data;

  const RemoteStorageSettingsPageState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory RemoteStorageSettingsPageState.common(
      {required RemoteStorageConfigurations data}) = CommonState;

  const factory RemoteStorageSettingsPageState.loading(
      {required RemoteStorageConfigurations data}) = LoadingState;

  const factory RemoteStorageSettingsPageState.didLogout(
      {required RemoteStorageConfigurations data}) = DidLogoutState;

  const factory RemoteStorageSettingsPageState.error({
    required RemoteStorageConfigurations data,
    required Object error,
  }) = ErrorState;
}

final class CommonState extends RemoteStorageSettingsPageState {
  const CommonState({required super.data});
}

final class DidLogoutState extends RemoteStorageSettingsPageState {
  const DidLogoutState({required super.data});
}

final class LoadingState extends RemoteStorageSettingsPageState {
  const LoadingState({required super.data});
}

final class ErrorState extends RemoteStorageSettingsPageState {
  final Object error;
  const ErrorState({
    required super.data,
    required this.error,
  });
}
