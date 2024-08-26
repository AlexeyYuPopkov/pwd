import 'package:equatable/equatable.dart';
import 'package:pwd/common/support/optional_box.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

/// Screen input data
sealed class EditNoteScreenInput {
  final String configId;
  const EditNoteScreenInput(this.configId);

  const factory EditNoteScreenInput.create({
    required String configId,
  }) = EditNoteScreenInputCreate._;

  const factory EditNoteScreenInput.update({
    required String configId,
    required String noteId,
  }) = EditNoteScreenInputUpdate._;
}

final class EditNoteScreenInputCreate extends EditNoteScreenInput {
  const EditNoteScreenInputCreate._({
    required String configId,
  }) : super(configId);
}

final class EditNoteScreenInputUpdate extends EditNoteScreenInput {
  final String noteId;

  const EditNoteScreenInputUpdate._({
    required String configId,
    required this.noteId,
  }) : super(configId);
}

// Data
final class EditNotePageData extends Equatable {
  final OptionalBox<BaseNoteItem> note;

  const EditNotePageData._({
    required this.note,
  });

  factory EditNotePageData.initial() => EditNotePageData._(
        note: OptionalBox.empty(),
      );

  @override
  List<Object?> get props => [note];

  EditNotePageData copyWith({
    OptionalBox<BaseNoteItem>? note,
  }) =>
      EditNotePageData._(
        note: note ?? this.note,
      );
}
