import 'package:pwd/notes/domain/database_path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';
import 'package:pwd/common/data_tools/mapper.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/notes_repository.dart';


class SqlDatasourceImpl implements NotesRepository {
  final DatabasePathProvider databasePathProvider;
  Database? _db;

  final Mapper<Map<String, Object?>, NoteItem> mapper;

  SqlDatasourceImpl({
    required this.databasePathProvider,
    required this.mapper,
  });

  Future<Database> get db async {
    if (_db is Database) {
      return _db as Database;
    } else {
      _db = await createDb();
      return _db as Database;
    }
  }

  Future<Database> createDb() async => openDatabase(
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
        mapper.toData(noteItem),
      ),
    );
  }

  @override
  Future<int> updatetNote(NoteItem noteItem) async {
    if (noteItem.id.isEmpty) {
      return insertNote(noteItem);
    } else {
      return db.then(
        (db) => db.update(
          CreateNotesTableIfAbsent.tableName,
          mapper.toData(noteItem),
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
      return mapper.toDomain(first);
    }
  }

  @override
  Future<List<NoteItem>> readNotes() async {
    final results = await db.then(
      (db) => db.query(
        CreateNotesTableIfAbsent.tableName,
      ),
    );

    return [
      for (final item in results) mapper.toDomain(item),
    ];
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
