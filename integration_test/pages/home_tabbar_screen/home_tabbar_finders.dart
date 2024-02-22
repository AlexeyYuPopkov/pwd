import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_screen_test_helper.dart';

final class HomeTabbarFinders {
  final configurationUndefinedItemIcon = find.byKey(
    const Key(HomeTabbarScreenTestKey.configurationUndefinedTabIcon),
  );

  final gitItemIcon = find.byKey(
    const Key(HomeTabbarScreenTestKey.gitTabIcon),
  );

  final settingsItemIcon = find.byKey(
    const Key(HomeTabbarScreenTestKey.settingsTabIcon),
  );
}
