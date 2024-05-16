part of 'configurations_screen.dart';

// Routing

sealed class ConfigurationScreenRoute {
  const ConfigurationScreenRoute();
}

final class OnPinPageRoute extends ConfigurationScreenRoute {
  const OnPinPageRoute();
}

final class OnSetupConfigurationRoute extends ConfigurationScreenRoute {
  final ConfigurationType type;
  final RemoteConfiguration? configuration;

  const OnSetupConfigurationRoute({
    required this.type,
    required this.configuration,
  });
}

final class MaybePopRoute extends ConfigurationScreenRoute {
  const MaybePopRoute();
}
