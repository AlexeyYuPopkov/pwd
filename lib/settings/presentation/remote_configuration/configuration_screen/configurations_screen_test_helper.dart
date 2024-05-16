import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

final class ConfigurationsScreenTestHelper {
  static String getItemKeyFor(ConfigurationType type) =>
      'ConfigurationsScreen.ConfigurationItem'
      '.${type.toString()}'
      '.Key';

  static const addNoteConfigurationButton = 'ConfigurationsScreen'
      '.AddNoteConfigurationButton.Key';

  static const noDataPlaceholder = 'ConfigurationsScreen.NoDataPlaceholder.Key';
  static const noDataPlaceholderButton =
      'ConfigurationsScreen.NoDataPlaceholderButton.Key';

  static const addActionSheetGoogleDrive = 'GoogleDrive';
  static const addActionSheetGit = 'Git';
  static const addActionSheetCancel = 'Cancel';
}
