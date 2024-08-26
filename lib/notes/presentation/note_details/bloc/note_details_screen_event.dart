import 'package:equatable/equatable.dart';

sealed class NoteDetailsScreenEvent extends Equatable {
  const NoteDetailsScreenEvent();

  const factory NoteDetailsScreenEvent.initial() = InitialEvent;

  @override
  List<Object?> get props => const [];
}

final class InitialEvent extends NoteDetailsScreenEvent {
  const InitialEvent();
}
