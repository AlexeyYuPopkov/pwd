import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pwd/notes/data/model/remote_db_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';
import 'package:pwd/common/data_tools/mapper.dart';
import 'package:pwd/notes/data/model/note_item_data.dart';
import 'package:pwd/notes/domain/database_path_provider.dart';
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
    const currentDbVersion = 3;
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
  Future<void> dropDb() {
    return db.then((db) async {
      const tableName = CreateNotesTableIfAbsent.tableName;
      const createRequest = DbRequest.createNotesTableIfAbsent();
      await db.transaction((transaction) async {
        await transaction.execute('DROP TABLE IF EXISTS $tableName');
        await transaction.execute(createRequest.query);
      });
    });
  }

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

          if (existedId is String && existedId == noteItem.id) {
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
  Future<int> delete(String id) async {
    return db.then(
      (db) => db.delete(
        CreateNotesTableIfAbsent.tableName,
        where: 'id = ?',
        whereArgs: [id],
      ),
    );
  }

  @override
  Future<NoteItem?> readNote(String id) async {
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
  Future<List<NoteItem>> readNotes() async => _readNotesDataList();

  @override
  Future<String> exportNotes() async {
    return jsonEncode(
      RemoteDbData(
        notes: await _readNotesDataList(),
        timestamp: await lastRecordTimestamp(),
      ).toJson(),
    );
  }

  @override
  Future<int> importNotes({
    required Map<String, dynamic> jsonMap,
  }) async {
    const tableName = CreateNotesTableIfAbsent.tableName;

    return db.then(
      (db) => db.transaction(
        (transaction) async {
          int changes = 0;

          final importResult = RemoteDbData.fromJson(jsonMap);

          for (final remoteItem in importResult.notes) {
            final result = await transaction.query(
              tableName,
              columns: ['id', 'timestamp'],
              where: 'id = ?',
              whereArgs: [remoteItem.id],
            );

            final dbItemMap = result.firstOrNull;
            final timestamp = dbItemMap?['timestamp'];
            final id = dbItemMap?['id'];

            // if (dbItemMap != null && id is int && timestamp is int && id > 0) {
            if (dbItemMap != null && timestamp is int) {
              if (timestamp < remoteItem.timestamp) {
                final map = remoteItem.toJson();
                changes += await transaction.update(
                  tableName,
                  map,
                  where: 'id = ?',
                  whereArgs: [id],
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );
              } else {
                final dbItem = NoteItemData.fromJson(dbItemMap);

                if (dbItem != remoteItem) {
                  changes++;
                }
              }
            } else {
              final map = remoteItem.toJson();
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

  @override
  String createEmptyDbContent(int timestamp) => jsonEncode(
        RemoteDbData(
          notes: const [],
          timestamp: timestamp,
        ).toJson(),
      );

  Future<List<NoteItemData>> _readNotesDataList() async => db
          .then(
        (db) => db.query(
          CreateNotesTableIfAbsent.tableName,
          orderBy: 'timestamp DESC',
        ),
      )
          .then(
        (src) {
          return [
            for (final item in src) mapper.dataFromMap(item),
          ];
        },
      );

  @override
  Future<int> lastRecordTimestamp() async {
    final results = await db.then(
      (db) => db.rawQuery(
        'SELECT MAX(timestamp) FROM ${CreateNotesTableIfAbsent.tableName}',
      ),
    );

    final first = results.firstOrNull;

    final timestamp = first?['MAX(timestamp)'];

    return timestamp is int ? timestamp : 0;
  }
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
      r'id VARCHAR PRIMARY KEY,'
      r'title TEXT,'
      r'description TEXT,'
      r'content TEXT,'
      r'timestamp TIMESTAMP'
      r')';
}
