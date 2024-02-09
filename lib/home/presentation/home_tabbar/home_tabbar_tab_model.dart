import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/notes/presentation/router/git_item_router_delegate.dart';
import 'package:pwd/notes/presentation/router/google_drive_item_router_delegate.dart';
import 'package:pwd/settings/presentation/router/settings_router_delegate.dart';

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

final class EmptyPlaceholderTab extends HomeTabbarTabModel {
  const EmptyPlaceholderTab();
  @override
  Widget buildRoute(BuildContext context) => const SizedBox();

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) =>
      const BottomNavigationBarItem(
        icon: SizedBox(),
        label: '',
      );

  @override
  NavigationRailDestination buildNavigationRailDestination(
    BuildContext context,
  ) =>
      const NavigationRailDestination(
        icon: SizedBox(),
        label: Text(''),
      );
}

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
