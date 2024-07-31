import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

final class HomeScreenTestHelper {
  static const configurationUndefinedFolderIcon =
      'ConfigurationUndefined.FolderIcon.TestKey';
  static String notesFolderIcon(RemoteConfiguration config) =>
      'GoogleDrive.FolderIcon.${config.id}.TestKey';
  static const settingsFolderIcon = 'Settings.FolderIcon.TestKey';
}
