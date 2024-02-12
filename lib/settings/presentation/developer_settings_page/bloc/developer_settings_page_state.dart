part of 'developer_settings_page_bloc.dart';

sealed class DeveloperSettingsPageState extends Equatable {
  final DeveloperSettingsPageData data;

  const DeveloperSettingsPageState({required this.data});

  @override
  List<Object?> get props => [data];

  bool get isSubmitEnabled =>
      data.initialAppConfiguration.data != data.appConfiguration;

  const factory DeveloperSettingsPageState.common(
      {required DeveloperSettingsPageData data}) = CommonState;

  const factory DeveloperSettingsPageState.loading(
      {required DeveloperSettingsPageData data}) = LoadingState;

  const factory DeveloperSettingsPageState.didSave(
      {required DeveloperSettingsPageData data}) = DidSaveState;

  const factory DeveloperSettingsPageState.error({
    required DeveloperSettingsPageData data,
    required Object error,
  }) = ErrorState;
}

final class CommonState extends DeveloperSettingsPageState {
  const CommonState({required super.data});
}

final class DidSaveState extends DeveloperSettingsPageState {
  const DidSaveState({required super.data});
}

final class LoadingState extends DeveloperSettingsPageState {
  const LoadingState({required super.data});
}

final class ErrorState extends DeveloperSettingsPageState {
  final Object error;
  const ErrorState({
    required super.data,
    required this.error,
  });
}
