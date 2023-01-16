import 'package:pwd/common/data/app_configuration_provider_impl.dart';
import 'package:pwd/common/data/pin_data_source.dart';
import 'package:pwd/common/data/remote_storage_configuration_provider_impl.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';

import 'package:pwd/common/domain/pin_repository.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';

class UnauthDiModule extends DiModule {
  @override
  void bind(DiStorage di) {
    di.bind<PinRepository>(
      module: this,
      () => PinDataSource(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<HashUsecase>(
      module: this,
      () => HashUsecase(pinRepository: di.resolve()),
      lifeTime: const LifeTime.single(),
    );

    di.bind<AppConfigurationProvider>(
      module: null,
      () => AppConfigurationProviderImpl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<RemoteStorageConfigurationProvider>(
      module: null,
      () => RemoteStorageConfigurationProviderImpl(),
      lifeTime: const LifeTime.single(),
    );
  }
}
