sealed class SettingsRouteData {
  const SettingsRouteData();

  factory SettingsRouteData.onRemoteConfiguration() = RemoteConfigurationScreen;

  factory SettingsRouteData.onDeveloperSettingsScreen() =
      OnDeveloperSettingsScreen;

  factory SettingsRouteData.onBleTestScreen() = OnBleTestScreen;
}

final class RemoteConfigurationScreen extends SettingsRouteData {
  const RemoteConfigurationScreen();
}

final class OnDeveloperSettingsScreen extends SettingsRouteData {
  const OnDeveloperSettingsScreen();
}

final class OnBleTestScreen extends SettingsRouteData {
  const OnBleTestScreen();
}
