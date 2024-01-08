import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/local_repository.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase_variant.dart';

final class SqlToRealmUsecase {
  final NotesProviderUsecase notesProviderUsecase;
  final NotesProviderUsecaseVariant notesProviderUsecaseVariant;
  final LocalRepository repository;
  final PinUsecase pinUsecase;

  SqlToRealmUsecase({
    required this.notesProviderUsecase,
    required this.notesProviderUsecaseVariant,
    required this.repository,
    required this.pinUsecase,
  });

  Future<void> call() async {
    await notesProviderUsecase.readNotes();
    final pin = pinUsecase.getPinOrThrow();
    repository.deleteAll(key: pin.pinSha512);
    final notes = notesProviderUsecase.notes;
    repository.saveNotes(key: pin.pinSha512, notes: notes);
    await notesProviderUsecaseVariant.readNotes();
  }
}
