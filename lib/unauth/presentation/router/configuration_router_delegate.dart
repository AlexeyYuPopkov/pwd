import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/presentation/router/base_router_delegate.dart';
import 'package:pwd/unauth/presentation/configuration_screen/configurations_screen.dart';
import 'package:pwd/unauth/presentation/configuration_screen/git_configuration_screen.dart';
import 'package:pwd/unauth/presentation/configuration_screen/google_drive_configuration_screen.dart';

final class ConfigurationRouterDelegatePath {
  static const configuration = 'configuration';
}

final _navigatorKey = GlobalKey<NavigatorState>();

final class ConfigurationRouterDelegate extends BaseRouterDelegate {
  @override
  GlobalKey<NavigatorState> navigatorKey;

  ConfigurationRouterDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
  }) : navigatorKey = navigatorKey ?? _navigatorKey;

  @override
  late List<Page> initialPages = [
    MaterialPage(
      child: ConfigurationsScreen(onRoute: onRoute),
      name: ConfigurationRouterDelegatePath.configuration,
    ),
  ];

  @override
  Future onRoute(BuildContext context, Object action) async {
    if (action is ConfigurationScreenRoute) {
      switch (action) {
        case OnPinPageRoute():
          return;
        case OnSetupConfigurationRoute():
          switch (action.type) {
            case ConfigurationType.git:
              return context.navigator.push(
                MaterialPageRoute(
                  builder: (_) => const GitConfigurationScreen(),
                ),
              );

            case ConfigurationType.googleDrive:
              return context.navigator.push(
                MaterialPageRoute(
                  builder: (_) => const GoogleDriveConfigurationScreen(),
                ),
              );
          }
      }
    }
  }
}

extension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
}
