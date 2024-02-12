part of 'git_notes_list_bloc.dart';

abstract class GitNotesListEvent extends Equatable {
  const GitNotesListEvent();

  const factory GitNotesListEvent.forceCreateRemoteSyncFile() =
      ForceCreateRemoteSyncFileEvent;

  const factory GitNotesListEvent.newData({required List<NoteItem> notes}) =
      NewDataEvent;

  const factory GitNotesListEvent.error(Object error) = ErrorEvent;

  const factory GitNotesListEvent.shouldSync() = ShouldSyncEvent;

  const factory GitNotesListEvent.refresh() = RefreshDataEvent;

  const factory GitNotesListEvent.sync() = SyncEvent;

  @override
  List<Object?> get props => const [];
}

class ForceCreateRemoteSyncFileEvent extends GitNotesListEvent {
  const ForceCreateRemoteSyncFileEvent();
}

class NewDataEvent extends GitNotesListEvent {
  final List<NoteItem> notes;
  const NewDataEvent({required this.notes});
}

class ErrorEvent extends GitNotesListEvent {
  final Object error;
  const ErrorEvent(this.error);
}

class RefreshDataEvent extends GitNotesListEvent {
  const RefreshDataEvent();
}

class ShouldSyncEvent extends GitNotesListEvent {
  const ShouldSyncEvent();
}

class SyncEvent extends GitNotesListEvent {
  const SyncEvent();
}
