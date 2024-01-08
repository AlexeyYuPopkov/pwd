import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/data/datasource/database_path_provider_impl.dart';
import 'package:pwd/notes/data/datasource/sql_datasource_impl.dart';
import 'package:pwd/notes/data/mappers/db_note_mapper.dart';
import 'package:pwd/notes/domain/database_path_provider.dart';

import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/domain/notes_repository.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase_variant.dart';

class NotesDi extends DiModule {
  @override
  void bind(DiStorage di) {
    di.bind<DatabasePathProvider>(
      module: this,
      () => DatabasePathProviderImpl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<NotesRepository>(
      module: this,
      () => SqlDatasourceImpl(
        databasePathProvider: di.resolve(),
        mapper: DbNoteMapper(),
      ),
      lifeTime: const LifeTime.single(),
    );

    di.bind<NotesProviderUsecase>(
      module: this,
      () => NotesProviderUsecaseImpl(
        repository: di.resolve(),
        hashUsecase: di.resolve(),
        pinRepository: di.resolve(),
      ),
      lifeTime: const LifeTime.single(),
    );

    di.bind<NotesProviderUsecaseVariant>(
      module: this,
      () => NotesProviderUsecaseVariantImpl(
        repository: di.resolve(),
        pinUsecase: di.resolve(),
      ),
      lifeTime: const LifeTime.single(),
    );
  }
}
