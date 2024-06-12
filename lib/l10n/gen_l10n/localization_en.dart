import 'localization.dart';

/// The translations for English (`en`).
class LocalizationEn extends Localization {
  LocalizationEn([String locale = 'en']) : super(locale);

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonAppend => 'Append';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonFieldValidatorMessageNotEmpty =>
      'The field should not be empty';

  @override
  String get commonFieldValidatorMessageWrongFormat =>
      'Invalid characters found';

  @override
  String get commonFieldValidatorMessageMinLength => 'Incorrect length';

  @override
  String get commonFieldValidatorMessageMaxLength => 'Incorrect length';

  @override
  String get remoteConfigurationsErrorMaxCount =>
      'Max count of possible configurations is 4';

  @override
  String get remoteConfigurationsErrorFilenemeDublicate =>
      'A configuration with the same name already exists';

  @override
  String get localStorageErrorPinDoesntMatch => 'Pin does not match';

  @override
  String get syncDataErrorUnkhown => 'Error when sync data';

  @override
  String clocksWidgetAddClockDialogTimeZoneOffsetLabel(String hours) {
    return 'Time zone offset: $hours';
  }

  @override
  String get clocksWidgetAddClockDialogSaveClockLabel => 'Save clock';

  @override
  String get pinScreenEnterPinFormLabelPin => 'Pin';

  @override
  String get pinScreenEnterPinFormButtonLogin => 'Login';

  @override
  String get homeScreenTabbarHome => 'Home';

  @override
  String get homeScreenTabbarSettings => 'Settings';

  @override
  String get configurationUndefinedScreenLabel =>
      'Synchronization methods are not defined';

  @override
  String get configurationUndefinedScreenButton => 'Setup synchronization';

  @override
  String get editNoteScreenScreenTitle => 'Add/Edit note';

  @override
  String get editNoteScreenTitleField => 'Title';

  @override
  String get editNoteScreenDescriptionField => 'Description';

  @override
  String get editNoteScreenContentField => 'Content';

  @override
  String get editNoteScreenDeleteConfirmationMessage =>
      'Do you really whant to delete the entry?';

  @override
  String get noteDetailsScreenTitle => 'Details';

  @override
  String get noteDetailsScreenTooltipMessage => 'Copied';

  @override
  String get notesListScreenTitle => 'Notes';

  @override
  String get configurationsScreenHeaderText => 'Sync. method';

  @override
  String get configurationsScreenActionSheetHeaderTitle =>
      'Synchronisation methods';

  @override
  String get configurationsScreenActionSheetCancelButtonTitle => 'Cancel';

  @override
  String get configurationsScreenNoDataPlaceholder =>
      'Setup synchronization method';

  @override
  String get configurationsScreenNoDataButtonTitle => 'Continue';

  @override
  String get configurationsScreenItemLabelGit => 'Git';

  @override
  String get configurationsScreenItemLabelGoogleDrive => 'Google Drive';

  @override
  String get gitConfigurationScreenTitle => 'Setup synchronization';

  @override
  String get gitConfigurationFormFormDescription =>
      'Enter repository details and file name for synchronization';

  @override
  String get gitConfigurationFormTokenTextField => 'Token';

  @override
  String get gitConfigurationFormTokenTooltip =>
      'Go to your GitHub account (Settings -> Developer settings -> Tokens -> Generate new token) and create access token and enter it here';

  @override
  String get gitConfigurationFormRepoTextFieldHint => 'Repository';

  @override
  String get gitConfigurationFormRepoTooltip =>
      'Create GitHub repository than enter it name here';

  @override
  String get gitConfigurationFormOwnerTextFieldHint => 'Owner';

  @override
  String get gitConfigurationFormOwnerTooltip => 'Enter your GitHub username';

  @override
  String get gitConfigurationFormBranchTextFieldHint => 'Branch';

  @override
  String get gitConfigurationFormBranchTooltip =>
      'Create branch in your repository and enter branch name here';

  @override
  String get gitConfigurationFormFileNameTextFieldHint => 'File name';

  @override
  String get gitConfigurationFormFileTooltip =>
      'Create [your repo]/[your brunch]/[file_name ] and enter [file_name]';

  @override
  String get gitConfigurationFormConfirmationMessageDeleteTitle => 'Warning';

  @override
  String get gitConfigurationFormConfirmationMessageDeleteMessage =>
      'Are you sure you want delete configuration from the device?';

  @override
  String get googleDriveConfigurationScreenTitle => 'Setup synchronization';

  @override
  String get googleDriveConfigurationScreenDescription =>
      'Fill form to setup synchronization via Google drive API';

  @override
  String get googleDriveConfigurationScreenFileNameTextFieldHint => 'File Name';

  @override
  String get googleDriveConfigurationScreenFileNameTooltip =>
      'Name of file for synchronization';

  @override
  String get googleDriveConfigurationScreenConfirmationMessageDeleteTitle =>
      'Warning';

  @override
  String get googleDriveConfigurationScreenConfirmationMessageDeleteMessage =>
      'Setup synchronization';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get settingsScreenRemoteConfigurationItem =>
      'Synchronisation settings';

  @override
  String get settingsScreenDeveloperSettingsItem => 'Developer settings';

  @override
  String get settingsScreenLogoutItem => 'Logout';

  @override
  String get developerSettingsScreenTitle => 'Developer settings';

  @override
  String get developerSettingsScreenProxyLabel => 'Proxy';

  @override
  String get developerSettingsScreenOtherLabel => 'Other';

  @override
  String get developerSettingsScreenOshowRawErrorsLabel => 'Show raw errors';

  @override
  String get developerSettingsScreenOshowRawErrorsDescription =>
      'If `true` ugly but informative errors will be shown';

  @override
  String get developerSettingsScreenProxyFormProxyLabel => 'Proxy:';

  @override
  String get developerSettingsScreenProxyFormPortLabel => 'Proxy port:';
}
