import 'package:flutter/foundation.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

abstract interface class RealmLocalRepository {
  Future<void> close();

  Future<void> delete(String id, {required List<int>? key});

  Future<void> deleteAll({required List<int>? key});

  Future<void> saveNotes({
    required List<int>? key,
    required List<NoteItem> notes,
  });

  Future<NoteItem?> readNote(
    String id, {
    required List<int>? key,
  });

  Future<List<NoteItem>> readNotes({
    required List<int>? key,
  });

  Future<void> updateNote(
    NoteItem noteItem, {
    required List<int>? key,
  });

  // Future<int> getTimestamp({required List<int>? key});

  Future<Uint8List> readAsBytes({required List<int>? key});

  Future<void> migrateWithDatabasePath({
    required Uint8List bytes,
    required List<int>? key,
    required Set<String> deleted,
  });
}
