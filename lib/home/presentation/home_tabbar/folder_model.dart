import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/home/presentation/home_tabbar/home_screen.dart';
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

sealed class FolderModel extends Equatable {
  static final settingsRouterKey =
      GlobalKey<NavigatorState>(debugLabel: 'Settings Router Key');

  static final tabRouterKeys = _TabRouterKeys();

  const FolderModel();

  NavigationRailDestination buildNavigationRailDestination(
    BuildContext context,
  );

  Widget buildDrawerItemIcon(BuildContext context);
  String buildDrawerItemName(BuildContext context);

  Widget folderDrawerItem(
    BuildContext context, {
    required bool isSelected,
    required VoidCallback? onTap,
  });
}

final class ConfigurationUndefinedItem extends FolderModel {
  const ConfigurationUndefinedItem();
  @override
  NavigationRailDestination buildNavigationRailDestination(
    BuildContext context,
  ) =>
      NavigationRailDestination(
        icon: const Icon(
          Icons.home,
          key: Key(
            HomeScreenTestHelper.configurationUndefinedFolderIcon,
          ),
          size: CommonSize.iconSize,
        ),
        label: Text(
          context.configurationUndefinedItemName,
        ),
      );

  @override
  List<Object?> get props => [runtimeType];

  @override
  Widget buildDrawerItemIcon(BuildContext context) => const SizedBox();

  @override
  String buildDrawerItemName(BuildContext context) => '';

  @override
  Widget folderDrawerItem(
    BuildContext context, {
    required bool isSelected,
    required VoidCallback? onTap,
  }) =>
      FolderDrawerItem(item: this, isSelected: isSelected, onTap: onTap);
}

// Git tab
final class NotesItem extends FolderModel {
  final RemoteConfiguration configuration;

  const NotesItem({required this.configuration});

  @override
  NavigationRailDestination buildNavigationRailDestination(
      BuildContext context) {
    return NavigationRailDestination(
      icon: Icon(
        Icons.folder_outlined,
        key: Key(HomeScreenTestHelper.notesFolderIcon(configuration)),
        size: CommonSize.iconSize,
      ),
      label: Text(configuration.fileName),
    );
  }

  @override
  List<Object?> get props => [runtimeType, configuration];

  @override
  Widget buildDrawerItemIcon(BuildContext context) => const Icon(
        Icons.folder_outlined,
        size: CommonSize.iconSize,
      );

  @override
  String buildDrawerItemName(BuildContext context) => configuration.fileName;

  @override
  Widget folderDrawerItem(
    BuildContext context, {
    required bool isSelected,
    required VoidCallback? onTap,
  }) =>
      FolderDrawerItem(item: this, isSelected: isSelected, onTap: onTap);
}

// Settings item
final class SettingsItem extends FolderModel {
  const SettingsItem();

  @override
  NavigationRailDestination buildNavigationRailDestination(
    BuildContext context,
  ) {
    return NavigationRailDestination(
      icon: const Icon(
        Icons.settings,
        key: Key(HomeScreenTestHelper.settingsFolderIcon),
        size: CommonSize.iconSize,
      ),
      label: Text(context.settingsItemName),
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
  String buildDrawerItemName(BuildContext context) => context.settingsItemName;

  @override
  Widget folderDrawerItem(
    BuildContext context, {
    required bool isSelected,
    required VoidCallback? onTap,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            // height: CommonSize.thickness,
            indent: CommonSize.indent2x,
          ),
          FolderDrawerItem(item: this, isSelected: isSelected, onTap: onTap),
        ],
      );
}

// Logout item
final class LogoutItem extends FolderModel {
  const LogoutItem();

  @override
  NavigationRailDestination buildNavigationRailDestination(
    BuildContext context,
  ) {
    return NavigationRailDestination(
      icon: const Icon(
        Icons.logout_outlined,
        size: CommonSize.iconSize,
      ),
      label: Text(context.settingsItemName),
    );
  }

  @override
  List<Object?> get props => [runtimeType];

  @override
  Widget buildDrawerItemIcon(BuildContext context) => const Icon(
        Icons.logout_outlined,
        size: CommonSize.iconSize,
      );

  @override
  String buildDrawerItemName(BuildContext context) => context.logoutItemName;

  @override
  Widget folderDrawerItem(
    BuildContext context, {
    required bool isSelected,
    required VoidCallback? onTap,
  }) =>
      FolderDrawerItem(item: this, isSelected: isSelected, onTap: onTap);
}

// Localization
extension on BuildContext {
  String get configurationUndefinedItemName =>
      localization.homeScreenTabbarHome;
  String get settingsItemName => localization.homeScreenTabbarSettings;
  String get logoutItemName => localization.homeScreenLogoutItem;
}
