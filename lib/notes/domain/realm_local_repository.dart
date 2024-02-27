import 'package:flutter/foundation.dart';
import 'package:pwd/common/domain/model/remote_configuration/local_storage_target.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

abstract interface class RealmLocalRepository {
  Future<void> delete(String id, {required LocalStorageTarget target});

  Future<void> deleteAll({required LocalStorageTarget target});

  Future<void> saveNotes({
    required LocalStorageTarget target,
    required List<NoteItem> notes,
  });

  Future<NoteItem?> readNote(
    String id, {
    required LocalStorageTarget target,
  });

  Future<List<NoteItem>> readNotes({
    required LocalStorageTarget target,
  });

  Future<void> updateNote(
    NoteItem noteItem, {
    required LocalStorageTarget target,
  });

  Future<Uint8List> readAsBytes({
    required LocalStorageTarget target,
  });

  Future<void> migrateWithDatabasePath({
    required Uint8List bytes,
    required LocalStorageTarget target,
    required Set<String> deleted,
  });
}
