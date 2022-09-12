part of 'note_page_bloc.dart';

abstract class NotePageEvent extends Equatable {
  const NotePageEvent();

  const factory NotePageEvent.start() = StartEvent;

  const factory NotePageEvent.login({
    required void Function(String) onLaunchWebCallback,
  }) = LoginEvent;

  @override
  List<Object?> get props => const [];
}

class StartEvent extends NotePageEvent {
  const StartEvent();
}

class LoginEvent extends NotePageEvent {
  final void Function(String) onLaunchWebCallback;

  const LoginEvent({required this.onLaunchWebCallback});
}
