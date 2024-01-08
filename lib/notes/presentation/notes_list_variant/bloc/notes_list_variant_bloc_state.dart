import 'package:equatable/equatable.dart';
import 'package:pwd/notes/domain/usecases/get_google_file_list_usecase.dart';
import 'notes_list_variant_bloc_data.dart';

sealed class NotesListVariantBlocState extends Equatable {
  final NotesListVariantBlocData data;

  const NotesListVariantBlocState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory NotesListVariantBlocState.common({
    required NotesListVariantBlocData data,
  }) = CommonState;

  const factory NotesListVariantBlocState.loading({
    required NotesListVariantBlocData data,
  }) = LoadingState;

  const factory NotesListVariantBlocState.error({
    required NotesListVariantBlocData data,
    required Object e,
  }) = ErrorState;
}

class InitialState extends NotesListVariantBlocState {
  const InitialState({required super.data});
}

class CommonState extends NotesListVariantBlocState {
  const CommonState({required super.data});
}

class LoadingState extends NotesListVariantBlocState {
  const LoadingState({required super.data});
}

class ErrorState extends NotesListVariantBlocState {
  final Object e;
  const ErrorState({
    required super.data,
    required this.e,
  });
}

class FilesListState extends NotesListVariantBlocState {
  final List<RemoteFile> files;
  const FilesListState({
    required super.data,
    required this.files,
  });
}
