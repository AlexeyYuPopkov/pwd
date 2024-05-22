import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/presentation/router/configuration_undefined_tab_router_delegate.dart';
import 'package:pwd/notes/presentation/router/notes_router_delegate.dart';

import 'package:pwd/settings/presentation/router/settings_router_delegate.dart';
import 'package:pwd/theme/common_size.dart';

import 'home_tabbar_screen_test_helper.dart';

final _settingsRouterKey = GlobalKey<NavigatorState>();

final _tabRouterKeys = _TabRouterKeys();

final class _TabRouterKeys {
  Map<String, GlobalKey<NavigatorState>> map = {};

  GlobalKey<NavigatorState> getKey(RemoteConfiguration config) {
    final id = config.id;
    final result = map[id];

    if (result == null) {
      final key = GlobalKey<NavigatorState>();
      map[id] = key;
      return key;
    } else {
      return result;
    }
  }
}

sealed class HomeTabbarTabModel {
  const HomeTabbarTabModel();
  Widget buildRoute(BuildContext context);

  BottomNavigationBarItem buildNavigationBarItem(BuildContext context);

  NavigationRailDestination buildNavigationRailDestination(
    BuildContext context,
  );
}

final class ConfigurationUndefinedTab extends HomeTabbarTabModel {
  const ConfigurationUndefinedTab();
  @override
  Widget buildRoute(BuildContext context) {
    return Router(
      routerDelegate: ConfigurationUndefinedTabRouterDelegate(),
    );
  }

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) =>
      BottomNavigationBarItem(
        icon: const Icon(
          Icons.home,
          key: Key(
            HomeTabbarScreenTestKey.configurationUndefinedTabIcon,
          ),
          size: CommonSize.iconSize,
        ),
        label: context.configurationUndefinedTabName,
      );

  @override
  NavigationRailDestination buildNavigationRailDestination(
    BuildContext context,
  ) =>
      NavigationRailDestination(
        icon: const Icon(
          Icons.home,
          key: Key(
            HomeTabbarScreenTestKey.configurationUndefinedTabIcon,
          ),
          size: CommonSize.iconSize,
        ),
        label: Text(
          context.configurationUndefinedTabName,
        ),
      );
}

// Git tab
final class GitTab extends HomeTabbarTabModel {
  final RemoteConfiguration configuration;

  const GitTab({required this.configuration});

  @override
  Router buildRoute(BuildContext context) {
    return Router(
      routerDelegate: NotesRouterDelegate(
        navigatorKey: _tabRouterKeys.getKey(configuration),
        configuration: configuration,
      ),
    );
  }

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
        key: Key(HomeTabbarScreenTestKey.notesTabIcon(configuration)),
        size: CommonSize.iconSize,
      ),
      label: configuration.fileName,
    );
  }

  @override
  NavigationRailDestination buildNavigationRailDestination(
      BuildContext context) {
    return NavigationRailDestination(
      icon: Icon(
        Icons.home,
        key: Key(HomeTabbarScreenTestKey.notesTabIcon(configuration)),
        size: CommonSize.iconSize,
      ),
      label: Text(configuration.fileName),
    );
  }
}

// Google drive tab
final class GoogleDriveTab extends HomeTabbarTabModel {
  final GoogleDriveConfiguration configuration;

  const GoogleDriveTab({required this.configuration});

  @override
  Router buildRoute(BuildContext context) {
    return Router(
      routerDelegate: NotesRouterDelegate(
        navigatorKey: _tabRouterKeys.getKey(configuration),
        configuration: configuration,
      ),
    );
  }

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Icon(
        Icons.list,
        key: Key(HomeTabbarScreenTestKey.notesTabIcon(configuration)),
        size: CommonSize.iconSize,
      ),
      label: configuration.fileName,
    );
  }

  @override
  NavigationRailDestination buildNavigationRailDestination(
      BuildContext context) {
    return NavigationRailDestination(
      icon: Icon(
        Icons.list,
        key: Key(HomeTabbarScreenTestKey.notesTabIcon(configuration)),
        size: CommonSize.iconSize,
      ),
      label: Text(configuration.fileName),
    );
  }
}

// Settings tab
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
        key: Key(HomeTabbarScreenTestKey.settingsTabIcon),
        size: CommonSize.iconSize,
      ),
      label: context.settingsTabName,
    );
  }

  @override
  NavigationRailDestination buildNavigationRailDestination(
    BuildContext context,
  ) {
    return NavigationRailDestination(
      icon: const Icon(
        Icons.settings,
        key: Key(HomeTabbarScreenTestKey.settingsTabIcon),
        size: CommonSize.iconSize,
      ),
      label: Text(context.settingsTabName),
    );
  }
}

// Localization
extension on BuildContext {
  String get configurationUndefinedTabName => 'Home';
  String get settingsTabName => 'Settings';
}
