part of 'edit_note_bloc.dart';

sealed class EditNoteState extends Equatable {
  final EditNotePageData data;

  const EditNoteState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory EditNoteState.common({required EditNotePageData data}) =
      CommonState;

  const factory EditNoteState.loading({required EditNotePageData data}) =
      LoadingState;

  const factory EditNoteState.didSave({required EditNotePageData data}) =
      DidSaveState;

  const factory EditNoteState.didDelete({required EditNotePageData data}) =
      DidDeleteState;

  const factory EditNoteState.error({
    required EditNotePageData data,
    required Object e,
  }) = ErrorState;
}

final class CommonState extends EditNoteState {
  const CommonState({required super.data});
}

final class DidSaveState extends EditNoteState {
  const DidSaveState({required super.data});
}

final class DidDeleteState extends EditNoteState {
  const DidDeleteState({required super.data});
}

final class LoadingState extends EditNoteState {
  const LoadingState({required super.data});
}

final class ErrorState extends EditNoteState {
  final Object e;
  const ErrorState({
    required super.data,
    required this.e,
  });
}

// Data
final class EditNotePageData extends Equatable {
  final BaseNoteItem noteItem;

  const EditNotePageData({required this.noteItem});

  @override
  List<Object?> get props => [noteItem];

  EditNotePageData copyWith({
    BaseNoteItem? noteItem,
  }) =>
      EditNotePageData(
        noteItem: noteItem ?? this.noteItem,
      );
}
