import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/settings/presentation/settings_page/settings_screen_test_helper.dart';

final class SettingsScreenFinders {
  final remoteConfigurationItem = find.byKey(
    const Key(SettingsScreenTestHelper.remoteConfigurationItem),
  );
  final developerSettingsItem = find.byKey(
    const Key(SettingsScreenTestHelper.developerSettingsItem),
  );
  final logoutItem = find.byKey(
    const Key(SettingsScreenTestHelper.logoutItem),
  );
}
