import 'package:equatable/equatable.dart';
import 'package:pwd/notes/presentation/note_details/bloc/note_details_screen_data.dart';

sealed class NoteDetailsScreenState extends Equatable {
  final NoteDetailsScreenData data;

  const NoteDetailsScreenState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory NoteDetailsScreenState.common({
    required NoteDetailsScreenData data,
  }) = CommonState;

  const factory NoteDetailsScreenState.loading({
    required NoteDetailsScreenData data,
  }) = LoadingState;

  const factory NoteDetailsScreenState.error({
    required NoteDetailsScreenData data,
    required Object e,
  }) = ErrorState;
}

final class CommonState extends NoteDetailsScreenState {
  const CommonState({required super.data});
}

final class LoadingState extends NoteDetailsScreenState {
  const LoadingState({required super.data});
}

final class ErrorState extends NoteDetailsScreenState {
  final Object e;
  const ErrorState({
    required super.data,
    required this.e,
  });
}
