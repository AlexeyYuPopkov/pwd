import 'package:equatable/equatable.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

abstract class Note extends Equatable {
  const Note();
  String get id;
  List<NoteItem> get notes;

  @override
  List<Object?> get props => [id, notes];

  const factory Note.empty() = EmptyNote;
}

class EmptyNote extends Note {
  const EmptyNote();

  @override
  String get id => '';

  @override
  List<NoteItem> get notes => [];
}
