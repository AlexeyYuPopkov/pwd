import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

final class HomeTabbarScreenTestKey {
  static const configurationUndefinedTabIcon =
      'ConfigurationUndefined.TabIcon.TestKey';
  // static const gitTabIcon = 'Git.TabIcon.TestKey';
  static String notesTabIcon(RemoteConfiguration config) =>
      'GoogleDrive.TabIcon.${config.id}.TestKey';
  static const settingsTabIcon = 'Settings.TabIcon.TestKey';
}
