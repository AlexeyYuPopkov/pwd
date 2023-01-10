part of 'note_page_bloc.dart';

abstract class NotePageState extends Equatable {
  final NotePageData data;

  const NotePageState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory NotePageState.common({required NotePageData data}) =
      CommonState;

  const factory NotePageState.loadingState({required NotePageData data}) =
      LoadingState;

  const factory NotePageState.error({
    required NotePageData data,
    required Object error,
  }) = ErrorState;
}

class CommonState extends NotePageState {
  const CommonState({required NotePageData data}) : super(data: data);
}

class LoadingState extends NotePageState {
  const LoadingState({required NotePageData data}) : super(data: data);
}

class ErrorState extends NotePageState {
  final Object error;
  const ErrorState({
    required NotePageData data,
    required this.error,
  }) : super(data: data);
}

// Data
class NotePageData extends Equatable {
  final Note note;

  const NotePageData._({required this.note});

  factory NotePageData.initial() => const NotePageData._(note: EmptyNote());

  @override
  List<Object?> get props => [note];

  NotePageData copyWith({
    Note? note,
  }) {
    return NotePageData._(
      note: note ?? this.note,
    );
  }
}
