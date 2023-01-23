import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pwd/common/data/app_configuration_provider_impl.dart';
import 'package:pwd/common/data/pin_repository_impl.dart';
import 'package:pwd/common/data/remote_storage_configuration_provider_impl.dart';
import 'package:pwd/common/data/remote_storage_configuration_provider_macos_impl.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';
import 'package:pwd/common/domain/pin_repository.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';

class UnauthDiModule extends DiModule {
  bool get _isMacOS => !kIsWeb && Platform.isMacOS;

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
      () => HashUsecase(
        pin: pinRepository.getPin(),
      ),
    );

    di.bind<AppConfigurationProvider>(
      module: null,
      () => AppConfigurationProviderImpl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<RemoteStorageConfigurationProvider>(
      module: null,
      () => _isMacOS
          ? RemoteStorageConfigurationProviderMacosImpl()
          : RemoteStorageConfigurationProviderImpl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind(
      module: this,
      () => ShouldCreateRemoteStorageFileUsecase(),
      lifeTime: const LifeTime.single(),
    );
  }
}
