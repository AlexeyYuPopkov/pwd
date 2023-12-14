import 'package:equatable/equatable.dart';

sealed class NotesListVariantBlocEvent extends Equatable {
  const NotesListVariantBlocEvent();

  const factory NotesListVariantBlocEvent.initial() = InitialEvent;

  @override
  List<Object?> get props => const [];
}

class InitialEvent extends NotesListVariantBlocEvent {
  const InitialEvent();
}
