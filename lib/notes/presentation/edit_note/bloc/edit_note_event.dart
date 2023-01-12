part of 'edit_note_bloc.dart';

abstract class EditNoteEvent extends Equatable {
  const EditNoteEvent();

  const factory EditNoteEvent.save({
    required String title,
    required String description,
    required String content,
  }) = SaveEvent;

  @override
  List<Object?> get props => const [];
}

class SaveEvent extends EditNoteEvent {
  final String title;
  final String description;
  final String content;

  const SaveEvent({
    required this.title,
    required this.description,
    required this.content,
  });
}
