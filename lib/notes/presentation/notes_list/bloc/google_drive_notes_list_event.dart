import 'package:equatable/equatable.dart';

sealed class GoogleDriveNotesListEvent extends Equatable {
  const GoogleDriveNotesListEvent();

  const factory GoogleDriveNotesListEvent.initial() = InitialEvent;

  const factory GoogleDriveNotesListEvent.error({
    required Object e,
  }) = ErrorEvent;

  const factory GoogleDriveNotesListEvent.sync({required bool force}) =
      SyncEvent;

  const factory GoogleDriveNotesListEvent.reloadLocally() = ReloadLocallyEvent;

  @override
  List<Object?> get props => const [];
}

final class InitialEvent extends GoogleDriveNotesListEvent {
  const InitialEvent();
}

final class ErrorEvent extends GoogleDriveNotesListEvent {
  final Object e;
  const ErrorEvent({required this.e});
}

final class SyncEvent extends GoogleDriveNotesListEvent {
  final bool force;
  const SyncEvent({required this.force});
}

final class ReloadLocallyEvent extends GoogleDriveNotesListEvent {
  const ReloadLocallyEvent();
}
