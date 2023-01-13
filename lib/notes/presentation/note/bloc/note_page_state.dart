part of 'note_page_bloc.dart';

abstract class NotePageState extends Equatable {
  final NotePageData data;

  const NotePageState({required this.data});

  @override
  List<Object?> get props => [data, needsSync];

  const factory NotePageState.common({required NotePageData data}) =
      CommonState;

  const factory NotePageState.loading({required NotePageData data}) =
      LoadingState;

  const factory NotePageState.error({
    required NotePageData data,
    required Object error,
  }) = ErrorState;

  bool get needsSync => data.needsToSync;
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
  final bool needsToSync;
  final List<NoteItem> notes;

  const NotePageData._({required this.needsToSync, required this.notes});

  factory NotePageData.initial() => const NotePageData._(
        notes: [],
        needsToSync: true,
      );

  @override
  List<Object?> get props => [notes];

  NotePageData copyWith({
    bool? needsToSync,
    List<NoteItem>? notes,
  }) {
    return NotePageData._(
      needsToSync: needsToSync ?? this.needsToSync,
      notes: notes ?? this.notes,
    );
  }
}
