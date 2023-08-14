import 'package:sqflite/sqflite.dart';
import 'package:pwd/notes/domain/database_path_provider.dart';

const _databaseName = 'note_data.db';

class DatabasePathProviderImpl implements DatabasePathProvider {
  DatabasePathProviderImpl();

  String? _path;

  @override
  Future<String> get path async {
    var thePath = _path;
    if (thePath == null || thePath.isEmpty) {
      final thePath = await getDatabasesPath().then(
        (databasesPath) => [
          databasesPath,
          _databaseName,
        ].join('/'),
      );

      _path = thePath;

      return thePath;
    } else {
      return thePath;
    }
  }
}
