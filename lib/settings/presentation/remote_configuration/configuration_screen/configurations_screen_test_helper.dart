final class ConfigurationsScreenTestHelper {
  static const backButton = 'ConfigurationsScreen.AppBar.BackButton.Key';
  static String getItemKeyFor(String id) =>
      'ConfigurationsScreen.ConfigurationItem'
      '.$id'
      '.Key';

  static String getReorderIconKeyFor(String id) =>
      'ConfigurationsScreen.ReorderableListItem'
      '.$id'
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
