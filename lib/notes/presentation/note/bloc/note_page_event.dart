part of 'note_page_bloc.dart';

abstract class NotePageEvent extends Equatable {
  const NotePageEvent();

  const factory NotePageEvent.newData({required Note note}) = NewDataEvent;

  const factory NotePageEvent.shouldUpdateNote({required NoteItem noteItem}) =
      ShouldUpdateNoteItemEvent;

  const factory NotePageEvent.login({
    required void Function(String) onLaunchWebCallback,
  }) = LoginEvent;

  @override
  List<Object?> get props => const [];
}

class NewDataEvent extends NotePageEvent {
  final Note note;
  const NewDataEvent({required this.note});
}

class ShouldUpdateNoteItemEvent extends NotePageEvent {
  final NoteItem noteItem;
  const ShouldUpdateNoteItemEvent({required this.noteItem});
}

class LoginEvent extends NotePageEvent {
  final void Function(String) onLaunchWebCallback;

  const LoginEvent({required this.onLaunchWebCallback});
}
