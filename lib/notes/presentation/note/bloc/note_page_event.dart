part of 'note_page_bloc.dart';

abstract class NotePageEvent extends Equatable {
  const NotePageEvent();

  const factory NotePageEvent.newData({required List<NoteItem> notes}) = NewDataEvent;

  const factory NotePageEvent.shouldUpdateNote({required NoteItem noteItem}) =
      ShouldUpdateNoteItemEvent;

  const factory NotePageEvent.login({
    required void Function(String) onLaunchWebCallback,
  }) = LoginEvent;

  @override
  List<Object?> get props => const [];
}

class NewDataEvent extends NotePageEvent {
  final List<NoteItem> notes;
  const NewDataEvent({required this.notes});
}

class ShouldUpdateNoteItemEvent extends NotePageEvent {
  final NoteItem noteItem;
  const ShouldUpdateNoteItemEvent({required this.noteItem});
}

class LoginEvent extends NotePageEvent {
  final void Function(String) onLaunchWebCallback;

  const LoginEvent({required this.onLaunchWebCallback});
}
