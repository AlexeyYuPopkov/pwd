import 'package:rxdart/rxdart.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/model/user_session.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';

final class UserSessionProviderUsecase {
  final PinUsecase pinUsecase;
  final RemoteStorageConfigurationProvider remoteStorageConfigurationProvider;

  UserSessionProviderUsecase({
    required this.pinUsecase,
    required this.remoteStorageConfigurationProvider,
  });

  UserSession curentUserSession = const UnconfiguredSession();

  late final Stream<UserSession> userSession = Rx.combineLatest2(
    remoteStorageConfigurationProvider.configuration,
    pinUsecase.pinStream,
    (appConfiguration, basePin) {
      return appConfiguration.isValid
          ? _withAppConfiguration(
              basePin: basePin,
              appConfiguration: appConfiguration,
            )
          : const UnconfiguredSession();

      // switch (appConfiguration) {
      //   case RemoteStorageConfigurationEmpty():
      //     return const UnconfiguredSession();
      //   case GitConfiguration():
      //     return _withAppConfiguration(
      //       basePin: basePin,
      //       appConfiguration: appConfiguration,
      //     );
      // }
    },
  ).distinct().doOnData((e) => curentUserSession = e).asBroadcastStream();
}

// Private
extension on UserSessionProviderUsecase {
  UserSession _withAppConfiguration({
    required BasePin basePin,
    required RemoteStorageConfigurations appConfiguration,
  }) {
    switch (basePin) {
      case Pin():
        return ValidSession(
          appConfiguration: appConfiguration,
          pin: basePin,
        );

      case EmptyPin():
        return UnauthorizedSession(appConfiguration: appConfiguration);
    }
  }
}
