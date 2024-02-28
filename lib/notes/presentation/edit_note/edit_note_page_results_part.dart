part of 'edit_note_screen.dart';

sealed class EditNotePagePopResult {
  const EditNotePagePopResult();

  const factory EditNotePagePopResult.didUpdate(
      {required BaseNoteItem noteItem}) = DidUpdateResult;

  const factory EditNotePagePopResult.didDidDelete() = DidDeleteResult;
}

final class DidUpdateResult extends EditNotePagePopResult {
  final BaseNoteItem noteItem;

  const DidUpdateResult({required this.noteItem});
}

final class DidDeleteResult extends EditNotePagePopResult {
  const DidDeleteResult();
}

typedef _TestHelper = EditNoteScreenTestHelper;
