import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localization_en.dart';
import 'localization_ru.dart';

/// Callers can lookup localized strings with an instance of Localization
/// returned by `Localization.of(context)`.
///
/// Applications need to include `Localization.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/localization.dart';
///
/// return MaterialApp(
///   localizationsDelegates: Localization.localizationsDelegates,
///   supportedLocales: Localization.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the Localization.supportedLocales
/// property.
abstract class Localization {
  Localization(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static Localization? of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  static const LocalizationsDelegate<Localization> delegate =
      _LocalizationDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonAppend.
  ///
  /// In en, this message translates to:
  /// **'Append'**
  String get commonAppend;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonFieldValidatorMessageNotEmpty.
  ///
  /// In en, this message translates to:
  /// **'The field should not be empty'**
  String get commonFieldValidatorMessageNotEmpty;

  /// No description provided for @commonFieldValidatorMessageWrongFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid characters found'**
  String get commonFieldValidatorMessageWrongFormat;

  /// No description provided for @commonFieldValidatorMessageMinLength.
  ///
  /// In en, this message translates to:
  /// **'Incorrect length'**
  String get commonFieldValidatorMessageMinLength;

  /// No description provided for @commonFieldValidatorMessageMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Incorrect length'**
  String get commonFieldValidatorMessageMaxLength;

  /// No description provided for @remoteConfigurationsErrorMaxCount.
  ///
  /// In en, this message translates to:
  /// **'Max count of possible configurations is 4'**
  String get remoteConfigurationsErrorMaxCount;

  /// No description provided for @remoteConfigurationsErrorFilenemeDublicate.
  ///
  /// In en, this message translates to:
  /// **'A configuration with the same name already exists'**
  String get remoteConfigurationsErrorFilenemeDublicate;

  /// No description provided for @localStorageErrorPinDoesntMatch.
  ///
  /// In en, this message translates to:
  /// **'Pin does not match'**
  String get localStorageErrorPinDoesntMatch;

  /// No description provided for @syncDataErrorUnkhown.
  ///
  /// In en, this message translates to:
  /// **'Error when sync data'**
  String get syncDataErrorUnkhown;

  /// No description provided for @clocksWidgetAddClockDialogTimeZoneOffsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Time zone offset: {hours}'**
  String clocksWidgetAddClockDialogTimeZoneOffsetLabel(String hours);

  /// No description provided for @clocksWidgetAddClockDialogSaveClockLabel.
  ///
  /// In en, this message translates to:
  /// **'Save clock'**
  String get clocksWidgetAddClockDialogSaveClockLabel;

  /// No description provided for @pinScreenEnterPinFormLabelPin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pinScreenEnterPinFormLabelPin;

  /// No description provided for @pinScreenEnterPinFormButtonLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get pinScreenEnterPinFormButtonLogin;

  /// No description provided for @homeScreenTabbarHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeScreenTabbarHome;

  /// No description provided for @homeScreenTabbarSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeScreenTabbarSettings;

  /// No description provided for @configurationUndefinedScreenLabel.
  ///
  /// In en, this message translates to:
  /// **'Synchronization methods are not defined'**
  String get configurationUndefinedScreenLabel;

  /// No description provided for @configurationUndefinedScreenButton.
  ///
  /// In en, this message translates to:
  /// **'Setup synchronization'**
  String get configurationUndefinedScreenButton;

  /// No description provided for @editNoteScreenScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Add/Edit note'**
  String get editNoteScreenScreenTitle;

  /// No description provided for @editNoteScreenTitleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get editNoteScreenTitleField;

  /// No description provided for @editNoteScreenDescriptionField.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get editNoteScreenDescriptionField;

  /// No description provided for @editNoteScreenContentField.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get editNoteScreenContentField;

  /// No description provided for @editNoteScreenDeleteConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you really whant to delete the entry?'**
  String get editNoteScreenDeleteConfirmationMessage;

  /// No description provided for @noteDetailsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get noteDetailsScreenTitle;

  /// No description provided for @noteDetailsScreenTooltipMessage.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get noteDetailsScreenTooltipMessage;

  /// No description provided for @notesListScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesListScreenTitle;

  /// No description provided for @configurationsScreenHeaderText.
  ///
  /// In en, this message translates to:
  /// **'Sync. method'**
  String get configurationsScreenHeaderText;

  /// No description provided for @configurationsScreenActionSheetHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Synchronisation methods'**
  String get configurationsScreenActionSheetHeaderTitle;

  /// No description provided for @configurationsScreenActionSheetCancelButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get configurationsScreenActionSheetCancelButtonTitle;

  /// No description provided for @configurationsScreenNoDataPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Setup synchronization method'**
  String get configurationsScreenNoDataPlaceholder;

  /// No description provided for @configurationsScreenNoDataButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get configurationsScreenNoDataButtonTitle;

  /// No description provided for @configurationsScreenItemLabelGit.
  ///
  /// In en, this message translates to:
  /// **'Git'**
  String get configurationsScreenItemLabelGit;

  /// No description provided for @configurationsScreenItemLabelGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get configurationsScreenItemLabelGoogleDrive;

  /// No description provided for @gitConfigurationScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup synchronization'**
  String get gitConfigurationScreenTitle;

  /// No description provided for @gitConfigurationFormFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter repository details and file name for synchronization'**
  String get gitConfigurationFormFormDescription;

  /// No description provided for @gitConfigurationFormTokenTextField.
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get gitConfigurationFormTokenTextField;

  /// No description provided for @gitConfigurationFormTokenTooltip.
  ///
  /// In en, this message translates to:
  /// **'Go to your GitHub account (Settings -> Developer settings -> Tokens -> Generate new token) and create access token and enter it here'**
  String get gitConfigurationFormTokenTooltip;

  /// No description provided for @gitConfigurationFormRepoTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get gitConfigurationFormRepoTextFieldHint;

  /// No description provided for @gitConfigurationFormRepoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Create GitHub repository than enter it name here'**
  String get gitConfigurationFormRepoTooltip;

  /// No description provided for @gitConfigurationFormOwnerTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get gitConfigurationFormOwnerTextFieldHint;

  /// No description provided for @gitConfigurationFormOwnerTooltip.
  ///
  /// In en, this message translates to:
  /// **'Enter your GitHub username'**
  String get gitConfigurationFormOwnerTooltip;

  /// No description provided for @gitConfigurationFormBranchTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get gitConfigurationFormBranchTextFieldHint;

  /// No description provided for @gitConfigurationFormBranchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Create branch in your repository and enter branch name here'**
  String get gitConfigurationFormBranchTooltip;

  /// No description provided for @gitConfigurationFormFileNameTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get gitConfigurationFormFileNameTextFieldHint;

  /// No description provided for @gitConfigurationFormFileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Create [your repo]/[your brunch]/[file_name ] and enter [file_name]'**
  String get gitConfigurationFormFileTooltip;

  /// No description provided for @gitConfigurationFormConfirmationMessageDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get gitConfigurationFormConfirmationMessageDeleteTitle;

  /// No description provided for @gitConfigurationFormConfirmationMessageDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want delete configuration from the device?'**
  String get gitConfigurationFormConfirmationMessageDeleteMessage;

  /// No description provided for @googleDriveConfigurationScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup synchronization'**
  String get googleDriveConfigurationScreenTitle;

  /// No description provided for @googleDriveConfigurationScreenDescription.
  ///
  /// In en, this message translates to:
  /// **'Fill form to setup synchronization via Google drive API'**
  String get googleDriveConfigurationScreenDescription;

  /// No description provided for @googleDriveConfigurationScreenFileNameTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get googleDriveConfigurationScreenFileNameTextFieldHint;

  /// No description provided for @googleDriveConfigurationScreenFileNameTooltip.
  ///
  /// In en, this message translates to:
  /// **'Name of file for synchronization'**
  String get googleDriveConfigurationScreenFileNameTooltip;

  /// No description provided for @googleDriveConfigurationScreenConfirmationMessageDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get googleDriveConfigurationScreenConfirmationMessageDeleteTitle;

  /// No description provided for @googleDriveConfigurationScreenConfirmationMessageDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Setup synchronization'**
  String get googleDriveConfigurationScreenConfirmationMessageDeleteMessage;

  /// No description provided for @settingsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsScreenTitle;

  /// No description provided for @settingsScreenRemoteConfigurationItem.
  ///
  /// In en, this message translates to:
  /// **'Synchronisation settings'**
  String get settingsScreenRemoteConfigurationItem;

  /// No description provided for @settingsScreenDeveloperSettingsItem.
  ///
  /// In en, this message translates to:
  /// **'Developer settings'**
  String get settingsScreenDeveloperSettingsItem;

  /// No description provided for @settingsScreenLogoutItem.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settingsScreenLogoutItem;

  /// No description provided for @developerSettingsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Developer settings'**
  String get developerSettingsScreenTitle;

  /// No description provided for @developerSettingsScreenProxyLabel.
  ///
  /// In en, this message translates to:
  /// **'Proxy'**
  String get developerSettingsScreenProxyLabel;

  /// No description provided for @developerSettingsScreenOtherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get developerSettingsScreenOtherLabel;

  /// No description provided for @developerSettingsScreenOshowRawErrorsLabel.
  ///
  /// In en, this message translates to:
  /// **'Show raw errors'**
  String get developerSettingsScreenOshowRawErrorsLabel;

  /// No description provided for @developerSettingsScreenOshowRawErrorsDescription.
  ///
  /// In en, this message translates to:
  /// **'If `true` ugly but informative errors will be shown'**
  String get developerSettingsScreenOshowRawErrorsDescription;

  /// No description provided for @developerSettingsScreenProxyFormProxyLabel.
  ///
  /// In en, this message translates to:
  /// **'Proxy:'**
  String get developerSettingsScreenProxyFormProxyLabel;

  /// No description provided for @developerSettingsScreenProxyFormPortLabel.
  ///
  /// In en, this message translates to:
  /// **'Proxy port:'**
  String get developerSettingsScreenProxyFormPortLabel;
}

class _LocalizationDelegate extends LocalizationsDelegate<Localization> {
  const _LocalizationDelegate();

  @override
  Future<Localization> load(Locale locale) {
    return SynchronousFuture<Localization>(lookupLocalization(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_LocalizationDelegate old) => false;
}

Localization lookupLocalization(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return LocalizationEn();
    case 'ru':
      return LocalizationRu();
  }

  throw FlutterError(
      'Localization.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
