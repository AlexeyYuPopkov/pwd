part of 'developer_settings_page_bloc.dart';

abstract class DeveloperSettingsPageState extends Equatable {
  final AppConfiguration data;

  const DeveloperSettingsPageState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory DeveloperSettingsPageState.common(
      {required AppConfiguration data}) = CommonState;

  const factory DeveloperSettingsPageState.loading(
      {required AppConfiguration data}) = LoadingState;

  const factory DeveloperSettingsPageState.didSave(
      {required AppConfiguration data}) = DidSaveState;

  const factory DeveloperSettingsPageState.error({
    required AppConfiguration data,
    required Object error,
  }) = ErrorState;
}

class CommonState extends DeveloperSettingsPageState {
  const CommonState({required super.data});
}

class DidSaveState extends DeveloperSettingsPageState {
  const DidSaveState({required super.data});
}

class LoadingState extends DeveloperSettingsPageState {
  const LoadingState({required super.data});
}

class ErrorState extends DeveloperSettingsPageState {
  final Object error;
  const ErrorState({
    required super.data,
    required this.error,
  });
}
