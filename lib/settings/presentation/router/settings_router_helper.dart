import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pwd/settings/presentation/ble_test_screen/ble_test_screen.dart';
import 'package:pwd/settings/presentation/developer_settings_page/developer_settings_screen.dart';
import 'package:pwd/settings/presentation/router/configurations_router_helper.dart';
import 'package:pwd/settings/presentation/settings_page/settings_screen.dart';
import 'package:pwd/settings/presentation/settings_page/settings_screen_routes.dart';

import 'package:pwd/unauth/presentation/router/redirect_to_login_page_helper.dart';

final class SettingsRouterHelper with RedirectToLoginPageHelper {
  @override
  final bool Function() isAuthorized;

  late final configurationsRouterHelper = ConfigurationsRouterHelper(
    isAuthorized: isAuthorized,
  );

  SettingsRouterHelper({required this.isAuthorized});

  Widget get initialScreen => SettingsScreen(onRoute: _onRoute);

  late final router = [
    GoRoute(
      path: SettingsRouterConfigurationsPath.shortPath,
      builder: (context, state) => configurationsRouterHelper.initialScreen,
      redirect: redirectToLoginPage,
      routes: [...configurationsRouterHelper.routes],
    ),
    GoRoute(
      path: SettingsRouterDeveloperPath.shortPath,
      builder: (context, state) => const DeveloperSettingsScreen(),
      redirect: redirectToLoginPage,
    ),
    GoRoute(
      path: BleTestScreenRouterPath.shortPath,
      builder: (context, state) => const BleTestScreen(),
      redirect: redirectToLoginPage,
    ),
  ];

  Future _onRoute(BuildContext context, SettingsRouteData action) async {
    switch (action) {
      case RemoteConfigurationScreen():
        context.go(SettingsRouterConfigurationsPath.goPath());
        break;
      case OnDeveloperSettingsScreen():
        context.go(SettingsRouterDeveloperPath.goPath());
        break;
      case OnBleTestScreen():
        context.go(BleTestScreenRouterPath.goPath());
        break;
    }
  }
}

final class SettingsRouterDeveloperPath {
  static const shortPath = 'developer';
  static String goPath() => '/settings/developer';
}

final class SettingsRouterConfigurationsPath {
  static const shortPath = 'configurations';
  static String goPath() => '/settings/configurations';
}

final class BleTestScreenRouterPath {
  static const shortPath = 'ble_test_screen';
  static String goPath() => '/settings/ble_test_screen';
}
