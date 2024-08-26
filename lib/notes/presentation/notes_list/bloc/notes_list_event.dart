import 'package:equatable/equatable.dart';

sealed class NotesListEvent extends Equatable {
  const NotesListEvent();

  const factory NotesListEvent.initial() = InitialEvent;

  const factory NotesListEvent.error({
    required Object e,
  }) = ErrorEvent;

  const factory NotesListEvent.sync({required bool force}) = SyncEvent;

  const factory NotesListEvent.reloadLocally() = ReloadLocallyEvent;

  @override
  List<Object?> get props => const [];
}

final class InitialEvent extends NotesListEvent {
  const InitialEvent();
}

final class ErrorEvent extends NotesListEvent {
  final Object e;
  const ErrorEvent({required this.e});
}

final class SyncEvent extends NotesListEvent {
  final bool force;
  const SyncEvent({required this.force});
}

final class ReloadLocallyEvent extends NotesListEvent {
  const ReloadLocallyEvent();
}
