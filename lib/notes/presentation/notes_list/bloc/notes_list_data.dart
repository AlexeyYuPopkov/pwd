import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/support/optional_box.dart';

import 'package:pwd/notes/domain/model/note_item.dart';

final class NotesListData extends Equatable {
  final OptionalBox<RemoteConfiguration> configBox;
  final List<NoteItem> notes;

  const NotesListData._({required this.configBox, required this.notes});

  factory NotesListData.initial() {
    return const NotesListData._(
      configBox: OptionalBox(null),
      notes: [],
    );
  }

  @override
  List<Object?> get props => [notes, configBox];

  NotesListData copyWith({
    OptionalBox<RemoteConfiguration>? configBox,
    List<NoteItem>? notes,
  }) {
    return NotesListData._(
      configBox: configBox ?? this.configBox,
      notes: notes ?? this.notes,
    );
  }
}
