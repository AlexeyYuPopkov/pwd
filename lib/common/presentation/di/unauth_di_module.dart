import 'package:di_storage/di_storage.dart';
import 'package:pwd/common/data/app_configuration_provider_impl.dart';
import 'package:pwd/common/data/clock_configuration_provider_impl.dart';
import 'package:pwd/common/data/pin_repository_impl.dart';
import 'package:pwd/common/data/remote_configuration_provider_impl.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';
import 'package:pwd/common/domain/clock_configuration_provider.dart';
import 'package:pwd/common/domain/pin_repository.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/domain/usecases/clock_usecase.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/unauth/domain/usecases/login_usecase.dart';

final class UnauthDiModule extends DiScope {
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
        validDuration: const Duration(minutes: 15),
        repository: di.resolve(),
      ),
      lifeTime: const LifeTime.single(),
    );

    di.bind<AppConfigurationProvider>(
      module: null,
      () => AppConfigurationProviderImpl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<RemoteConfigurationProvider>(
      module: this,
      () => RemoteConfigurationProviderImpl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<TimeFormatter>(
      () => TimeFormatterImpl(),
      module: this,
      lifeTime: const LifeTime.prototype(),
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

    bindUsecases(di);
  }
}

// Bind usecases
extension on UnauthDiModule {
  void bindUsecases(DiStorage di) {
    di.bind<HashUsecase>(
      module: this,
      () => const HashUsecase(),
    );

    di.bind<LoginUsecase>(
      module: this,
      () => LoginUsecase(
        pinUsecase: di.resolve(),
        hashUsecase: di.resolve(),
      ),
    );
  }
}
