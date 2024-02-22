import 'package:flutter/material.dart';
import 'package:pwd/settings/presentation/developer_settings_page/developer_settings_page.dart';
import 'package:pwd/settings/presentation/settings_page/settings_screen.dart';

import 'package:pwd/common/presentation/fade_animation_page.dart';
import 'package:pwd/unauth/presentation/router/configuration_router_delegate.dart';

class SettingsRouterPagePath {
  static const settings = 'settings';
}

class SettingsRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  SettingsRouterDelegate({
    required this.navigatorKey,
  }); //: navigatorKey = navigatorKey ?? ;
// GlobalKey<NavigatorState>()
  void updateState() {
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        FadeAnimationPage(
          child: SettingsScreen(onRoute: _onRoute),
          name: SettingsRouterPagePath.settings,
        )
      ],
      onPopPage: (route, result) {
        updateState();
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

  Future _onRoute(BuildContext context, SettingsRouteData action) async {
    switch (action) {
      case RemoteConfigurationScreen():
        return context.navigator
            .push(
              MaterialPageRoute(
                builder: (_) => const ConfigurationsScreenRouterWidget(),
              ),
            )
            .then(
              (_) => updateState(),
            );
      case OnDeveloperSettingsPage():
        return context.navigator
            .push(
              MaterialPageRoute(
                builder: (_) => DeveloperSettingsPage(),
              ),
            )
            .then(
              (_) => updateState(),
            );
    }
  }

  @override
  final GlobalKey<NavigatorState>? navigatorKey;

  void parseUri(Uri uri) {}

  @override
  Future<void> setNewRoutePath(configuration) {
    return Future.value(null);
  }
}

class ConfigurationsScreenRouterWidget extends StatelessWidget {
  const ConfigurationsScreenRouterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: ConfigurationRouterDelegate(
        onPop: () => Navigator.of(context).maybePop(),
      ),
    );
  }
}

extension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
}
