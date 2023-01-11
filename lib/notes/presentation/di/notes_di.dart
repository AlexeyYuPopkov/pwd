import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/data/datasource/database_path_provider_impl.dart';
import 'package:pwd/notes/data/datasource/sql_datasource_impl.dart';
import 'package:pwd/notes/data/mappers/db_note_mapper.dart';
import 'package:pwd/notes/domain/database_path_provider.dart';
import 'package:pwd/notes/domain/notes_provider_impl.dart';
import 'package:pwd/notes/domain/notes_repository.dart';

class NotesDi extends DiModule {
  @override
  void bind(DiStorage di) {
    di.bind<DatabasePathProvider>(() => DatabasePathProviderImpl());
    
    di.bind<NotesRepository>(() => SqlDatasourceImpl(
          databasePathProvider: di.resolve(),
          mapper: DbNoteMapper(),
        ));

    di.bind<NotesProvider>(
      () => NotesProviderImpl(repository: di.resolve()),
    );
  }
}
