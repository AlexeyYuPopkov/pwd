part of 'edit_note_bloc.dart';

abstract class EditNoteState extends Equatable {
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

  const factory EditNoteState.error({
    required EditNotePageData data,
    required Object error,
  }) = ErrorState;
}

class CommonState extends EditNoteState {
  const CommonState({required EditNotePageData data}) : super(data: data);
}

class DidSaveState extends EditNoteState {
  const DidSaveState({required EditNotePageData data}) : super(data: data);
}

class LoadingState extends EditNoteState {
  const LoadingState({required EditNotePageData data}) : super(data: data);
}

class ErrorState extends EditNoteState {
  final Object error;
  const ErrorState({
    required EditNotePageData data,
    required this.error,
  }) : super(data: data);
}

// Data
class EditNotePageData extends Equatable {
  final NoteItem noteItem;

  const EditNotePageData({required this.noteItem});

  @override
  List<Object?> get props => [noteItem];

  EditNotePageData copyWith({
    NoteItem? noteItem,
  }) =>
      EditNotePageData(
        noteItem: noteItem ?? this.noteItem,
      );
}
