import 'package:equatable/equatable.dart';

import 'package:pwd/notes/domain/model/note_item.dart';

class NotesListVariantBlocData extends Equatable {
  final List<NoteItem> notes;

  const NotesListVariantBlocData._({required this.notes});

  factory NotesListVariantBlocData.initial() {
    return const NotesListVariantBlocData._(notes: []);
  }

  @override
  List<Object?> get props => [notes];

  NotesListVariantBlocData copyWith({
    List<NoteItem>? notes,
  }) {
    return NotesListVariantBlocData._(
      notes: notes ?? this.notes,
    );
  }
}
