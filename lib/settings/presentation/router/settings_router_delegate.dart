import 'package:flutter/material.dart';
import 'package:pwd/settings/presentation/developer_settings_page/developer_settings_page.dart';
import 'package:pwd/settings/presentation/settings_page/settings_page.dart';

import 'package:pwd/common/presentation/fade_animation_page.dart';
import 'package:pwd/settings/presentation/remote_storage_settings_page/remote_storage_settings_page.dart';

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
          child: SettingsPage(onRoute: _onRoute),
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
    if (action is OnRemoteStorageSettingsPage) {
      return context.navigator
          .push(
            MaterialPageRoute(
              builder: (_) => const RemoteStorageSettingsPage(),
            ),
          )
          .then(
            (_) => updateState(),
          );
    } else if (action is OnDeveloperSettingsPage) {
      return context.navigator
          .push(
            MaterialPageRoute(
              builder: (_) => const DeveloperSettingsPage(),
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

extension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
}
