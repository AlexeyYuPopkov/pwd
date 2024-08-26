import 'package:equatable/equatable.dart';
import 'package:pwd/notes/presentation/note_details/note_details_screen_list_model.dart';

final class NoteDetailsScreenData extends Equatable {
  final List<NoteDetailsScreenListModel> lines;
  const NoteDetailsScreenData._({required this.lines});

  factory NoteDetailsScreenData.initial() {
    return const NoteDetailsScreenData._(lines: []);
  }

  NoteDetailsScreenData copyWith({
    List<NoteDetailsScreenListModel>? lines,
  }) {
    return NoteDetailsScreenData._(
      lines: lines ?? this.lines,
    );
  }

  @override
  List<Object?> get props => [lines];
}
