import 'package:equatable/equatable.dart';

import 'package:pwd/notes/domain/model/note_item.dart';

class GoogleDriveNotesListData extends Equatable {
  final List<NoteItem> notes;

  const GoogleDriveNotesListData._({required this.notes});

  factory GoogleDriveNotesListData.initial() {
    return const GoogleDriveNotesListData._(notes: []);
  }

  @override
  List<Object?> get props => [notes];

  GoogleDriveNotesListData copyWith({
    List<NoteItem>? notes,
  }) {
    return GoogleDriveNotesListData._(
      notes: notes ?? this.notes,
    );
  }
}
