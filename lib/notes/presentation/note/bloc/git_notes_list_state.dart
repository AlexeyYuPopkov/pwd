part of 'git_notes_list_bloc.dart';

abstract class GitNotesListState extends Equatable {
  final NotePageData data;

  const GitNotesListState({required this.data});

  @override
  List<Object?> get props => [data, needsSync];

  const factory GitNotesListState.common({required NotePageData data}) =
      CommonState;

  const factory GitNotesListState.didSync({required NotePageData data}) =
      DidSyncState;

  const factory GitNotesListState.loading({required NotePageData data}) =
      LoadingState;

  const factory GitNotesListState.error({
    required NotePageData data,
    required Object error,
  }) = ErrorState;

  bool get needsSync => this is CommonState;
}

class CommonState extends GitNotesListState {
  const CommonState({required super.data});
}

class DidSyncState extends GitNotesListState {
  const DidSyncState({required super.data});
}

class LoadingState extends GitNotesListState {
  const LoadingState({required super.data});
}

class ErrorState extends GitNotesListState {
  final Object error;
  const ErrorState({
    required super.data,
    required this.error,
  });
}

// Data
class NotePageData extends Equatable {
  final List<NoteItem> notes;

  const NotePageData._({required this.notes});

  factory NotePageData.initial() => const NotePageData._(
        notes: [],
      );

  @override
  List<Object?> get props => [notes];

  NotePageData copyWith({
    List<NoteItem>? notes,
  }) {
    return NotePageData._(
      notes: notes ?? this.notes,
    );
  }
}
