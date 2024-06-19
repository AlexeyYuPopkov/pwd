import 'package:flutter/foundation.dart';
import 'package:pwd/common/domain/model/remote_configuration/local_storage_target.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

abstract interface class RealmLocalRepository {
  Stream<RealmLocalRepositoryNotification?> getChangesStream();
  Future<void> markDeleted(String id, {required LocalStorageTarget target});
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
    UpdatedNoteItem noteItem, {
    required LocalStorageTarget target,
  });

  Future<void> createNote(
    NewNoteItem noteItem, {
    required LocalStorageTarget target,
  });

  Future<Uint8List> readAsBytes({
    required LocalStorageTarget target,
  });

  Future<void> mergeWithDatabasePath({
    required Uint8List bytes,
    required LocalStorageTarget target,
  });

  Future<void> deleteCacheFile({
    required CacheTarget target,
  });
}

final class RealmLocalRepositoryNotification {
  final LocalStorageTarget target;

  const RealmLocalRepositoryNotification({required this.target});
}
