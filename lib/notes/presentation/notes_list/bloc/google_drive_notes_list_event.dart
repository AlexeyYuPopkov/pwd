import 'package:equatable/equatable.dart';

sealed class GoogleDriveNotesListEvent extends Equatable {
  const GoogleDriveNotesListEvent();

  const factory GoogleDriveNotesListEvent.initial() = InitialEvent;

  const factory GoogleDriveNotesListEvent.error({
    required Object e,
  }) = ErrorEvent;

  const factory GoogleDriveNotesListEvent.sync() = SyncEvent;

  // const factory NotesListVariantBlocEvent.sqlToRealm() = SqlToRealmEvent;

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
  const SyncEvent();
}

// final class SqlToRealmEvent extends NotesListVariantBlocEvent {
//   const SqlToRealmEvent();
// }
