import 'package:flutter/material.dart';

abstract base class BaseRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  GlobalKey<NavigatorState> get navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: initialPages,
      onPopPage: (route, result) {
        // updateState();
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

  @override
  Future<void> setNewRoutePath(configuration) async {}

  void updateState() {
    notifyListeners();
  }

  List<Page> get initialPages;

  Future onRoute(BuildContext context, Object action);
}

extension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
}
