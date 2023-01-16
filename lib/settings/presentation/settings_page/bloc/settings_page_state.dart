part of 'settings_page_bloc.dart';

abstract class SettingsPageState extends Equatable {
  final SettingsPageData data;

  const SettingsPageState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory SettingsPageState.common({required SettingsPageData data}) =
      CommonState;

  const factory SettingsPageState.loading({required SettingsPageData data}) =
      LoadingState;

  const factory SettingsPageState.didLogout({required SettingsPageData data}) =
      DidLogoutState;

  const factory SettingsPageState.error({
    required SettingsPageData data,
    required Object error,
  }) = ErrorState;
}

class CommonState extends SettingsPageState {
  const CommonState({required SettingsPageData data}) : super(data: data);
}

class DidLogoutState extends SettingsPageState {
  const DidLogoutState({required SettingsPageData data}) : super(data: data);
}

class LoadingState extends SettingsPageState {
  const LoadingState({required SettingsPageData data}) : super(data: data);
}

class ErrorState extends SettingsPageState {
  final Object error;
  const ErrorState({
    required SettingsPageData data,
    required this.error,
  }) : super(data: data);
}

// Data
class SettingsPageData extends Equatable {
  const SettingsPageData();

  @override
  List<Object?> get props => const [];
}
