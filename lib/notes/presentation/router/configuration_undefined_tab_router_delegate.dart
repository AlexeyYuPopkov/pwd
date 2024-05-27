import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/home/presentation/configuration_undefined_screen/configuration_undefined_screen.dart';
import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/configurations_screen.dart';
import 'package:pwd/settings/presentation/remote_configuration/git_configuration_screen/git_configuration_screen.dart';
import 'package:pwd/settings/presentation/remote_configuration/google_drive_configuration_screen/google_drive_configuration_screen.dart';

abstract final class ConfigurationUndefinedTabPagePath {
  static const home = 'home';
  static const configurations = 'home/configurations';
}

final _navigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'ConfigurationUndefinedTabRouterDelegate',
);

final class ConfigurationUndefinedTabRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  ConfigurationUndefinedTabRouterDelegate();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (context) => ConfigurationUndefinedScreen(onRoute: onRoute),
      ),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (context.navigator.canPop()) {
          return true;
        }

        return false;
      },
    );
  }

  Future onRoute(BuildContext context, Object action) async {
    if (action is ConfigurationUndefinedScreensRoute) {
      switch (action) {
        case ToSettingsRoute():
          return context.navigator.push(
            MaterialPageRoute(
              builder: (_) => ConfigurationsScreen(onRoute: onRoute),
            ),
          );
      }
    } else if (action is ConfigurationScreenRoute) {
      switch (action) {
        case OnPinPageRoute():
          return;
        case OnSetupConfigurationRoute():
          final configuration = action.configuration;
          switch (action.type) {
            case ConfigurationType.git:
              final git =
                  configuration is GitConfiguration ? configuration : null;
              return context.navigator.push(
                MaterialPageRoute(
                  builder: (_) => GitConfigurationScreen(
                    initial: git,
                  ),
                ),
              );

            case ConfigurationType.googleDrive:
              final googleDrive = configuration is GoogleDriveConfiguration
                  ? configuration
                  : null;
              return context.navigator.push(
                MaterialPageRoute(
                  builder: (_) => GoogleDriveConfigurationScreen(
                    initial: googleDrive,
                  ),
                ),
              );
          }
        case MaybePopRoute():
          context.navigator.maybePop();
          break;
      }
    }
  }

  @override
  Future<void> setNewRoutePath(configuration) async {}
}

extension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
}
