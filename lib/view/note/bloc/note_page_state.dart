part of 'note_page_bloc.dart';

abstract class NotePageState extends Equatable {
  final NotePageData data;

  const NotePageState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory NotePageState.initial({required NotePageData data}) =
      InitialState;

  const factory NotePageState.error({
    required NotePageData data,
    required Object error,
  }) = ErrorState;
}

class InitialState extends NotePageState {
  const InitialState({required NotePageData data}) : super(data: data);
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
  final List<NoteItem> items;

  const NotePageData._({required this.items});

  factory NotePageData.initial() => const NotePageData._(items: []);

  @override
  List<Object?> get props => const [];
}
