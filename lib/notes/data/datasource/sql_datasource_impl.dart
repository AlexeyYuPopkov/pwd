import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pwd/notes/data/model/note_item_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';
import 'package:pwd/notes/domain/database_path_provider.dart';
import 'package:pwd/common/data_tools/mapper.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/notes_repository.dart';

class SqlDatasourceImpl implements NotesRepository {
  final DatabasePathProvider databasePathProvider;
  Database? _db;

  final Mapper<NoteItemData, NoteItem> mapper;

  SqlDatasourceImpl({
    required this.databasePathProvider,
    required this.mapper,
  });

  Future<Database> get db async {
    if (_db is Database) {
      return _db as Database;
    } else {
      _db = await _openDb();
      return _db as Database;
    }
  }

  @override
  Future<void> updateDb({required String rawSql}) {
    return db.then(
      (db) async {
        final result = await db.rawQuery(rawSql);
        debugPrint(result.length.toString());
      },
    );
  }

  Future<Database> _openDb() async {
    const currentDbVersion = 2;
    const createRequest = DbRequest.createNotesTableIfAbsent();
    return openDatabase(
      await _databasePath,
      version: currentDbVersion,
      onCreate: (Database db, int version) async {
        await db.execute(createRequest.query);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          const tableName = CreateNotesTableIfAbsent.tableName;
          await db.transaction((transaction) async {
            await transaction.execute('DROP TABLE IF EXISTS $tableName');
            await transaction.execute(createRequest.query);
          });
        }
      },
    );
  }

  Future<String> get _databasePath => databasePathProvider.path;

  @override
  Future<int> updateNote(NoteItem noteItem) async {
    return db.then(
      (db) => db.transaction(
        (transaction) async {
          int changes = 0;

          final result = await transaction.query(
            CreateNotesTableIfAbsent.tableName,
            columns: ['id'],
            where: 'id = ?',
            whereArgs: [noteItem.id],
          );

          final existedId = result.firstOrNull?['id'];

          if (existedId is int && existedId == noteItem.id) {
            changes += await transaction.update(
              CreateNotesTableIfAbsent.tableName,
              where: 'id = ?',
              whereArgs: [noteItem.id],
              mapper.toData(noteItem).toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          } else {
            changes += await transaction.insert(
              CreateNotesTableIfAbsent.tableName,
              mapper.toData(noteItem).toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }

          return changes;
        },
      ),
    );
  }

  @override
  Future<int> delete(int id) async {
    return db.then(
      (db) => db.delete(
        CreateNotesTableIfAbsent.tableName,
        where: 'id = ?',
        whereArgs: [id],
      ),
    );
  }

  @override
  Future<NoteItem?> readNote(int id) async {
    final results = await db.then((db) => db.query(
          CreateNotesTableIfAbsent.tableName,
          where: 'id = ?',
          whereArgs: [id],
        ));

    final first = results.firstOrNull;

    if (first == null) {
      return null;
    } else {
      return mapper.toDomain(mapper.dataFromMap(first));
    }
  }

  @override
  Future<List<NoteItem>> readNotes() => exportNotes();

  @override
  Future<List<NoteItemData>> exportNotes() async {
    return db
        .then(
          (db) => db.query(
            CreateNotesTableIfAbsent.tableName,
            orderBy: 'timestamp DESC',
          ),
        )
        .then(
          (src) => [
            for (final item in src) mapper.dataFromMap(item),
          ],
        );
  }

  @override
  Future<int> importNotes({
    required List<NoteItemData> notes,
  }) async {
    const tableName = CreateNotesTableIfAbsent.tableName;

    return db.then(
      (db) => db.transaction(
        (transaction) async {
          int changes = 0;

          for (final note in notes) {
            final result = await transaction.query(
              tableName,
              columns: ['id', 'timestamp'],
              where: 'id = ?',
              whereArgs: [note.id],
            );

            final timestamp = result.firstOrNull?['timestamp'];
            final id = result.firstOrNull?['id'];

            if (id is int && id > 0) {
              if (timestamp is int && timestamp < note.timestamp) {
                final map = note.toJson();
                changes += await transaction.update(
                  tableName,
                  map,
                  where: 'id = ?',
                  whereArgs: [id],
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );
              } else {
                debugPrint('Nothing to do');
              }
            } else {
              final map = note.toJson();
              changes += await transaction.insert(
                tableName,
                map,
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          }

          return changes;
        },
      ),
    );
  }

  @override
  Future<void> close() => (_db?.close() ?? Future.value()).then(
        (_) => _db = null,
      );
}

abstract class DbRequest {
  const DbRequest();
  String get query;

  const factory DbRequest.createNotesTableIfAbsent() = CreateNotesTableIfAbsent;
}

class CreateNotesTableIfAbsent extends DbRequest {
  static const tableName = 'notes';

  const CreateNotesTableIfAbsent();

  @override
  String get query => 'CREATE TABLE $tableName'
      r'('
      r'id INTEGER PRIMARY KEY,'
      r'title TEXT,'
      r'description TEXT,'
      r'content TEXT,'
      r'timestamp TIMESTAMP'
      r')';
}
