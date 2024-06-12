import 'package:equatable/equatable.dart';
import 'package:pwd/notes/domain/model/google_drive_file.dart';
import 'google_drive_notes_list_data.dart';

sealed class GoogleDriveNotesListState extends Equatable {
  final GoogleDriveNotesListData data;

  const GoogleDriveNotesListState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory GoogleDriveNotesListState.common({
    required GoogleDriveNotesListData data,
  }) = CommonState;

  const factory GoogleDriveNotesListState.loading({
    required GoogleDriveNotesListData data,
  }) = LoadingState;

  const factory GoogleDriveNotesListState.syncLoading({
    required GoogleDriveNotesListData data,
  }) = SyncLoadingState;

  const factory GoogleDriveNotesListState.error({
    required GoogleDriveNotesListData data,
    required Object e,
  }) = ErrorState;
}

final class InitialState extends GoogleDriveNotesListState {
  const InitialState({required super.data});
}

final class CommonState extends GoogleDriveNotesListState {
  const CommonState({required super.data});
}

final class LoadingState extends GoogleDriveNotesListState {
  const LoadingState({required super.data});
}

final class SyncLoadingState extends GoogleDriveNotesListState {
  const SyncLoadingState({required super.data});
}

final class ErrorState extends GoogleDriveNotesListState {
  final Object e;
  const ErrorState({
    required super.data,
    required this.e,
  });
}

class FilesListState extends GoogleDriveNotesListState {
  final List<GoogleDriveFile> files;
  const FilesListState({
    required super.data,
    required this.files,
  });
}
