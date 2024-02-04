import 'package:pwd/common/data/app_configuration_provider_impl.dart';
import 'package:pwd/common/data/clock_configuration_provider_impl.dart';
import 'package:pwd/common/data/pin_repository_impl.dart';
import 'package:pwd/common/data/remote_storage_configuration_provider_macos_impl.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';
import 'package:pwd/common/domain/clock_configuration_provider.dart';
import 'package:pwd/common/domain/pin_repository.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/domain/usecases/clock_usecase.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';
import 'package:pwd/common/domain/usecases/user_session_provider_usecase.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';

final class UnauthDiModule extends DiModule {
  @override
  void bind(DiStorage di) {
    final PinRepository pinRepository = PinRepositoryImpl();

    di.bind<PinRepository>(
      module: this,
      () => pinRepository,
      lifeTime: const LifeTime.single(),
    );

    di.bind<PinUsecase>(
      module: this,
      () => PinUsecaseImpl(
        validDuration: const Duration(minutes: 10),
        repository: di.resolve(),
      ),
      lifeTime: const LifeTime.single(),
    );

    di.bind<HashUsecase>(
      module: this,
      () => const HashUsecase(),
    );

    di.bind<AppConfigurationProvider>(
      module: null,
      () => AppConfigurationProviderImpl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<UserSessionProviderUsecase>(
      module: null,
      () => UserSessionProviderUsecase(
        pinUsecase: di.resolve(),
        remoteStorageConfigurationProvider: di.resolve(),
      ),
      lifeTime: const LifeTime.single(),
    );

    di.bind<RemoteStorageConfigurationProvider>(
      module: null,
      () => RemoteStorageConfigurationProviderMacosImpl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind(
      module: this,
      () => ShouldCreateRemoteStorageFileUsecase(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<TimeFormatter>(
      () => TimeFormatterImpl(),
      module: this,
      lifeTime: const LifeTime.single(),
    );

    di.bind<ClockConfigurationProvider>(
      () => ClockConfigurationProviderImpl(),
      module: this,
      lifeTime: const LifeTime.single(),
    );

    di.bind<ClockUsecase>(
      () => ClockUsecase(
        clockConfigurationProvider: di.resolve(),
      ),
      module: this,
      lifeTime: const LifeTime.single(),
    );
    //
  }
}
