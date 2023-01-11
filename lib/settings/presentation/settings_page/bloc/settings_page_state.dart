part of 'settings_page_bloc.dart';

abstract class SettingsPageState extends Equatable {
  final EditNotePageData data;

  const SettingsPageState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory SettingsPageState.unauth({required EditNotePageData data}) =
      UnauthState;

  const factory SettingsPageState.didSync({required EditNotePageData data}) =
      DidSyncState;

  const factory SettingsPageState.loading({required EditNotePageData data}) =
      LoadingState;

  const factory SettingsPageState.error({
    required EditNotePageData data,
    required Object error,
  }) = ErrorState;
}

class UnauthState extends SettingsPageState {
  const UnauthState({required EditNotePageData data}) : super(data: data);
}

class DidSyncState extends SettingsPageState {
  const DidSyncState({required EditNotePageData data}) : super(data: data);
}

class LoadingState extends SettingsPageState {
  const LoadingState({required EditNotePageData data}) : super(data: data);
}

class ErrorState extends SettingsPageState {
  final Object error;
  const ErrorState({
    required EditNotePageData data,
    required this.error,
  }) : super(data: data);
}

// Data
class EditNotePageData extends Equatable {
  const EditNotePageData._();

  const factory EditNotePageData.initial() = EditNotePageData._;

  @override
  List<Object?> get props => [];
}
