import 'package:pwd/notes/domain/local_repository.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

final class SyncNotesVariantUsecase {
  final LocalRepository repository;

  SyncNotesVariantUsecase({required this.repository});

  Future<void> call({required List<NoteItem> notes}) {
    return repository.saveNotes(notes: notes);
  }
}
