import 'package:flutter/material.dart';
import 'package:pwd/notes/presentation/router/note_router_delegate.dart';
import 'package:pwd/notes/presentation/router/note_router_variant_delegate.dart';
import 'package:pwd/settings/presentation/router/settings_router_delegate.dart';

final _noteRouterKey = GlobalKey<NavigatorState>();
final _notesListRouterKey = GlobalKey<NavigatorState>();
final _settingsRouterKey = GlobalKey<NavigatorState>();

sealed class HomeTabbarTabModel {
  const HomeTabbarTabModel();
  Router buildRoute(BuildContext context);

  BottomNavigationBarItem buildNavigationBarItem(BuildContext context);

  NavigationRailDestination buildNavigationRailDestination(
      BuildContext context);

  static List<HomeTabbarTabModel> tabs = const [
    GitTab(),
    GoogleTab(),
    SettingsTab(),
  ];
}

final class GitTab extends HomeTabbarTabModel {
  const GitTab();
  @override
  Router buildRoute(BuildContext context) {
    return Router(
      routerDelegate: NoteRouterDelegate(navigatorKey: _noteRouterKey),
    );
  }

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: const Icon(Icons.home),
      label: context.gitTabName,
    );
  }

  @override
  NavigationRailDestination buildNavigationRailDestination(
      BuildContext context) {
    return NavigationRailDestination(
      icon: const Icon(Icons.home),
      label: Text(context.gitTabName),
    );
  }
}

final class GoogleTab extends HomeTabbarTabModel {
  const GoogleTab();
  @override
  Router buildRoute(BuildContext context) {
    return Router(
      routerDelegate: NoteRouterVariantDelegate(
        navigatorKey: _notesListRouterKey,
      ),
    );
  }

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: const Icon(Icons.list),
      label: context.googleTabName,
    );
  }

  @override
  NavigationRailDestination buildNavigationRailDestination(
      BuildContext context) {
    return NavigationRailDestination(
      icon: const Icon(Icons.list),
      label: Text(context.googleTabName),
    );
  }
}

final class SettingsTab extends HomeTabbarTabModel {
  const SettingsTab();
  @override
  Router buildRoute(BuildContext context) {
    return Router(
      routerDelegate: SettingsRouterDelegate(
        navigatorKey: _settingsRouterKey,
      ),
    );
  }

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: const Icon(
        Icons.settings,
        key: Key('test_bottom_navigation_bar_settings_item_icon'),
      ),
      label: context.settingsTabName,
    );
  }

  @override
  NavigationRailDestination buildNavigationRailDestination(
      BuildContext context) {
    return NavigationRailDestination(
      icon: const Icon(
        Icons.settings,
        key: Key('test_bottom_navigation_bar_settings_item_icon'),
      ),
      label: Text(context.settingsTabName),
    );
  }
}

extension on BuildContext {
  String get gitTabName => 'Git';
  String get googleTabName => 'Google';
  String get settingsTabName => 'Settings';
}
