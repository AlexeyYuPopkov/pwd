import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/notes/presentation/router/configuration_undefined_tab_router_delegate.dart';
import 'package:pwd/notes/presentation/router/git_item_router_delegate.dart';
import 'package:pwd/notes/presentation/router/google_drive_item_router_delegate.dart';
import 'package:pwd/settings/presentation/router/settings_router_delegate.dart';

import 'home_tabbar_screen_test_helper.dart';

final _noteRouterKey = GlobalKey<NavigatorState>();
final _notesListRouterKey = GlobalKey<NavigatorState>();
final _settingsRouterKey = GlobalKey<NavigatorState>();

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
  // const ConfigurationUndefinedScreen();

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) =>
      BottomNavigationBarItem(
        icon: const Icon(
          Icons.home,
          key: Key(
            HomeTabbarScreenTestKey.configurationUndefinedTabIcon,
          ),
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
        ),
        label: Text(
          context.configurationUndefinedTabName,
        ),
      );
}

// Git tab
final class GitTab extends HomeTabbarTabModel {
  final GitConfiguration configuration;

  const GitTab({required this.configuration});

  @override
  Router buildRoute(BuildContext context) {
    return Router(
      routerDelegate: GitItemRouterDelegate(
        navigatorKey: _noteRouterKey,
        configuration: configuration,
      ),
    );
  }

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: const Icon(
        Icons.home,
        key: Key(HomeTabbarScreenTestKey.gitTabIcon),
      ),
      label: context.gitTabName,
    );
  }

  @override
  NavigationRailDestination buildNavigationRailDestination(
      BuildContext context) {
    return NavigationRailDestination(
      icon: const Icon(
        Icons.home,
        key: Key(HomeTabbarScreenTestKey.gitTabIcon),
      ),
      label: Text(context.gitTabName),
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
      routerDelegate: GoogleDriveItemRouterDelegate(
        navigatorKey: _notesListRouterKey,
        configuration: configuration,
      ),
    );
  }

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: const Icon(
        Icons.list,
        key: Key(HomeTabbarScreenTestKey.googleDriveTabIcon),
      ),
      label: context.googleTabName,
    );
  }

  @override
  NavigationRailDestination buildNavigationRailDestination(
      BuildContext context) {
    return NavigationRailDestination(
      icon: const Icon(
        Icons.list,
        key: Key(HomeTabbarScreenTestKey.googleDriveTabIcon),
      ),
      label: Text(context.googleTabName),
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
      ),
      label: Text(context.settingsTabName),
    );
  }
}

// Localization
extension on BuildContext {
  String get configurationUndefinedTabName => 'Home';
  String get gitTabName => 'Git';
  String get googleTabName => 'Google';
  String get settingsTabName => 'Settings';
}
