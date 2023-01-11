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
      _db = await openDb();
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

  Future<Database> openDb() async => openDatabase(
        await _databasePath,
        version: 1,
        onCreate: (Database db, int version) async {
          const request = DbRequest.createNotesTableIfAbsent();
          await db.execute(request.query);
        },
      );

  Future<String> get _databasePath => databasePathProvider.path;

  @override
  Future<int> insertNote(NoteItem noteItem) async {
    return db.then(
      (db) => db.insert(
        CreateNotesTableIfAbsent.tableName,
        mapper.toData(noteItem).toJson(),
      ),
    );
  }

  @override
  Future<int> updatetNote(NoteItem noteItem) async {
    if (noteItem.id == null) {
      return insertNote(noteItem);
    } else {
      return db.then(
        (db) => db.update(
          CreateNotesTableIfAbsent.tableName,
          mapper.toData(noteItem).toJson(),
        ),
      );
    }
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
          ),
        )
        .then(
          (src) => [
            for (final item in src) mapper.dataFromMap(item),
          ],
        );
  }

  @override
  Future<void> importNotes(List<NoteItemData> notes) async {
    // var queryes = <String>[];

    const tableName = CreateNotesTableIfAbsent.tableName;

    // for (final note in notes) {
    //   queryes.add(
    //     'INSERT INTO '
    //     '$tableName (id, title, description, content, timestamp);',
    //   );
    // }

    return db.then(
      (db) {
        return db.transaction((transaction) async {
          for (final note in notes) {
            final map = note.toJson();
            await transaction.insert(
              tableName,
              map,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        });
      },
    ).catchError((e) {
      print(e.toString());
    });
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
      r'title varchar(32),'
      r'description varchar(255),'
      r'content TEXT,'
      r'timestamp TIMESTAMP'
      r')';
}
