part of 'note_page_bloc.dart';

abstract class NotePageEvent extends Equatable {
  const NotePageEvent();

  const factory NotePageEvent.newData({required List<NoteItem> notes}) =
      NewDataEvent;

        const factory NotePageEvent.error(Object error) =
      ErrorEvent;

  const factory NotePageEvent.shouldUpdateNote({required NoteItem noteItem}) =
      ShouldUpdateNoteItemEvent;

  const factory NotePageEvent.refresh() = RefreshDataEvent;

  const factory NotePageEvent.sync() = SyncEvent;

  @override
  List<Object?> get props => const [];
}

class NewDataEvent extends NotePageEvent {
  final List<NoteItem> notes;
  const NewDataEvent({required this.notes});
}

class ErrorEvent extends NotePageEvent {
  final Object error;
  const ErrorEvent(this.error);
}

class RefreshDataEvent extends NotePageEvent {
  const RefreshDataEvent();
}

class ShouldUpdateNoteItemEvent extends NotePageEvent {
  final NoteItem noteItem;
  const ShouldUpdateNoteItemEvent({required this.noteItem});
}

class SyncEvent extends NotePageEvent {
  const SyncEvent();
}
