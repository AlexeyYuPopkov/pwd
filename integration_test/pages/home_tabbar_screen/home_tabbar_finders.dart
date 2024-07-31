import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/home/presentation/home_tabbar/home_screen_test_helper.dart';

final class HomeTabbarFinders {
  final configurationUndefinedItemIcon = find.byKey(
    const Key(HomeScreenTestHelper.configurationUndefinedFolderIcon),
  );

  Finder notesTabIcon(RemoteConfiguration config) => find.byKey(
        Key(HomeScreenTestHelper.notesFolderIcon(config)),
      );

  final settingsItemIcon = find.byKey(
    const Key(HomeScreenTestHelper.settingsFolderIcon),
  );
}
