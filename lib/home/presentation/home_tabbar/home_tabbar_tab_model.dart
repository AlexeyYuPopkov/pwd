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

  NavigationRailDestination buildNavigationRailDestination(
    BuildContext context,
  );

  Widget buildDrawerItemIcon(BuildContext context);
  String buildDrawerItemName(BuildContext context);
}

final class ConfigurationUndefinedTab extends HomeTabbarTabModel {
  const ConfigurationUndefinedTab();
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

  @override
  Widget buildDrawerItemIcon(BuildContext context) => const SizedBox();

  @override
  String buildDrawerItemName(BuildContext context) => '';
}

// Git tab
final class NotesTab extends HomeTabbarTabModel {
  final RemoteConfiguration configuration;

  const NotesTab({required this.configuration});

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

  @override
  Widget buildDrawerItemIcon(BuildContext context) => const Icon(
        Icons.source,
        size: CommonSize.iconSize,
      );

  @override
  String buildDrawerItemName(BuildContext context) => configuration.fileName;
}

// Settings tab
final class SettingsTab extends HomeTabbarTabModel {
  const SettingsTab();

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

  @override
  Widget buildDrawerItemIcon(BuildContext context) => const Icon(
        Icons.settings,
        size: CommonSize.iconSize,
      );

  @override
  String buildDrawerItemName(BuildContext context) => context.settingsTabName;
}

// Localization
extension on BuildContext {
  String get configurationUndefinedTabName => localization.homeScreenTabbarHome;
  String get settingsTabName => localization.homeScreenTabbarSettings;
}
