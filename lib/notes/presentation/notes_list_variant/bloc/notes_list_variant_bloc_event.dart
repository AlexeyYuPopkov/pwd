import 'package:equatable/equatable.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

sealed class NotesListVariantBlocEvent extends Equatable {
  const NotesListVariantBlocEvent();

  const factory NotesListVariantBlocEvent.newNotes({
    required List<NoteItem> notes,
  }) = NewNotesEvent;

  const factory NotesListVariantBlocEvent.error({
    required Object e,
  }) = ErrorEvent;

  const factory NotesListVariantBlocEvent.saveNotes() = SaveNotesEvent;

  @override
  List<Object?> get props => const [];
}

final class NewNotesEvent extends NotesListVariantBlocEvent {
  final List<NoteItem> notes;
  const NewNotesEvent({required this.notes});
}

final class ErrorEvent extends NotesListVariantBlocEvent {
  final Object e;
  const ErrorEvent({required this.e});
}

final class SaveNotesEvent extends NotesListVariantBlocEvent {
  const SaveNotesEvent();
}
