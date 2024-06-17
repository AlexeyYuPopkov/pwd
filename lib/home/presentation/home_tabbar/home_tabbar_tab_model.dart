import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/l10n/localization_helper.dart';

import 'package:pwd/theme/common_size.dart';

import 'home_screen_test_helper.dart';

final class _TabRouterKeys {
  Map<String, GlobalKey<NavigatorState>> map = {};

  GlobalKey<NavigatorState> getKey(RemoteConfiguration config) {
    final id = config.id;
    final result = map[id];

    if (result == null) {
      final key = GlobalKey<NavigatorState>(debugLabel: id);
      map[id] = key;
      return key;
    } else {
      return result;
    }
  }
}

sealed class HomeTabbarTabModel extends Equatable {
  static final settingsRouterKey =
      GlobalKey<NavigatorState>(debugLabel: 'Settings Router Key');

  static final tabRouterKeys = _TabRouterKeys();

  const HomeTabbarTabModel();
  // Widget buildRoute(BuildContext context);

  BottomNavigationBarItem buildNavigationBarItem(BuildContext context);

  NavigationRailDestination buildNavigationRailDestination(
    BuildContext context,
  );
}

final class ConfigurationUndefinedTab extends HomeTabbarTabModel {
  const ConfigurationUndefinedTab();
  // @override
  // Widget buildRoute(BuildContext context) {
  //   return Router(
  //     routerDelegate: ConfigurationUndefinedTabRouterDelegate(),
  //   );
  // }

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) =>
      BottomNavigationBarItem(
        icon: const Icon(
          Icons.home,
          key: Key(
            HomeScreenTestHelper.configurationUndefinedTabIcon,
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
            HomeScreenTestHelper.configurationUndefinedTabIcon,
          ),
          size: CommonSize.iconSize,
        ),
        label: Text(
          context.configurationUndefinedTabName,
        ),
      );

  @override
  List<Object?> get props => [runtimeType];
}

// Git tab
final class NotesTab extends HomeTabbarTabModel {
  final RemoteConfiguration configuration;

  const NotesTab({required this.configuration});

  // @override
  // Router buildRoute(BuildContext context) {
  //   return Router(
  //     routerDelegate: NotesRouterDelegate(
  //       navigatorKey: HomeTabbarTabModel.tabRouterKeys.getKey(configuration),
  //       configuration: configuration,
  //     ),
  //   );
  // }

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
        key: Key(HomeScreenTestHelper.notesTabIcon(configuration)),
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
        key: Key(HomeScreenTestHelper.notesTabIcon(configuration)),
        size: CommonSize.iconSize,
      ),
      label: Text(configuration.fileName),
    );
  }

  @override
  List<Object?> get props => [runtimeType, configuration];
}

// Settings tab
final class SettingsTab extends HomeTabbarTabModel {
  const SettingsTab();
  // @override
  // Router buildRoute(BuildContext context) {
  //   return Router(
  //     routerDelegate: SettingsRouterDelegate(
  //       navigatorKey: HomeTabbarTabModel.settingsRouterKey,
  //     ),
  //   );
  // }

  @override
  BottomNavigationBarItem buildNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: const Icon(
        Icons.settings,
        key: Key(HomeScreenTestHelper.settingsTabIcon),
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
        key: Key(HomeScreenTestHelper.settingsTabIcon),
        size: CommonSize.iconSize,
      ),
      label: Text(context.settingsTabName),
    );
  }

  @override
  List<Object?> get props => [runtimeType];
}

// Localization
extension on BuildContext {
  String get configurationUndefinedTabName => localization.homeScreenTabbarHome;
  String get settingsTabName => localization.homeScreenTabbarSettings;
}
