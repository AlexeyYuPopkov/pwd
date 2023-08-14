part of 'note_page_bloc.dart';

abstract class NotePageState extends Equatable {
  final NotePageData data;

  const NotePageState({required this.data});

  @override
  List<Object?> get props => [data, needsSync];

  const factory NotePageState.common({required NotePageData data}) =
      CommonState;

  const factory NotePageState.didSync({required NotePageData data}) =
      DidSyncState;

  const factory NotePageState.loading({required NotePageData data}) =
      LoadingState;

  const factory NotePageState.error({
    required NotePageData data,
    required Object error,
  }) = ErrorState;

  bool get needsSync => this is CommonState;
}

class CommonState extends NotePageState {
  const CommonState({required super.data});
}

class DidSyncState extends NotePageState {
  const DidSyncState({required super.data});
}

class LoadingState extends NotePageState {
  const LoadingState({required super.data});
}

class ErrorState extends NotePageState {
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
