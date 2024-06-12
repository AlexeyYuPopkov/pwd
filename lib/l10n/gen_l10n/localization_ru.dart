import 'localization.dart';

/// The translations for Russian (`ru`).
class LocalizationRu extends Localization {
  LocalizationRu([String locale = 'ru']) : super(locale);

  @override
  String get commonOk => 'ОК';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonEdit => 'Редактировать';

  @override
  String get commonAppend => 'Добавить';

  @override
  String get commonDelete => 'Удалить';

  @override
  String get commonContinue => 'Продолжить';

  @override
  String get commonFieldValidatorMessageNotEmpty =>
      'Поле не должно быть пустым';

  @override
  String get commonFieldValidatorMessageWrongFormat => 'Найдены не';

  @override
  String get commonFieldValidatorMessageMinLength => 'Неправильная длина';

  @override
  String get commonFieldValidatorMessageMaxLength => 'Неправильная длина';

  @override
  String get remoteConfigurationsErrorMaxCount =>
      'Максимальное кол-во конфигураций - 4';

  @override
  String get remoteConfigurationsErrorFilenemeDublicate =>
      'Конфигурация с таким-же именем уже существует';

  @override
  String get localStorageErrorPinDoesntMatch => 'Неверный пин';

  @override
  String get syncDataErrorUnkhown => 'Ошибка синхронизации данных';

  @override
  String clocksWidgetAddClockDialogTimeZoneOffsetLabel(String hours) {
    return 'Часовой пояс: $hours';
  }

  @override
  String get clocksWidgetAddClockDialogSaveClockLabel => 'Сохранить';

  @override
  String get pinScreenEnterPinFormLabelPin => 'Пин';

  @override
  String get pinScreenEnterPinFormButtonLogin => 'Вход';

  @override
  String get homeScreenTabbarHome => 'Дом';

  @override
  String get homeScreenTabbarSettings => 'Настройки';

  @override
  String get configurationUndefinedScreenLabel =>
      'Методы синхронизации не определены';

  @override
  String get configurationUndefinedScreenButton => 'Настройка синхронизации';

  @override
  String get editNoteScreenScreenTitle => 'Добавить/изменить заметку';

  @override
  String get editNoteScreenTitleField => 'Заголовок';

  @override
  String get editNoteScreenDescriptionField => 'Описание';

  @override
  String get editNoteScreenContentField => 'Содержание';

  @override
  String get editNoteScreenDeleteConfirmationMessage =>
      'Вы действительно хотите удалить запись?';

  @override
  String get noteDetailsScreenTitle => 'Детали';

  @override
  String get noteDetailsScreenTooltipMessage => 'Скопировано';

  @override
  String get notesListScreenTitle => 'Заметки';

  @override
  String get configurationsScreenHeaderText => 'Метод синхронизации';

  @override
  String get configurationsScreenActionSheetHeaderTitle =>
      'Методы синхронизации';

  @override
  String get configurationsScreenActionSheetCancelButtonTitle => 'Отмена';

  @override
  String get configurationsScreenNoDataPlaceholder =>
      'Настройка метода синхронизации';

  @override
  String get configurationsScreenNoDataButtonTitle => 'Продолжить';

  @override
  String get configurationsScreenItemLabelGit => 'Git';

  @override
  String get configurationsScreenItemLabelGoogleDrive => 'Google Drive';

  @override
  String get gitConfigurationScreenTitle => 'Настройка синхронизации';

  @override
  String get gitConfigurationFormFormDescription =>
      'Введите данные репозитория и имя файла для синхронизации';

  @override
  String get gitConfigurationFormTokenTextField => 'Токен';

  @override
  String get gitConfigurationFormTokenTooltip =>
      'Перейдите в свою учетную запись GitHub (Settings -> Developer settings -> Tokens -> Generate new token) и создайте токен доступа и введите его здесь';

  @override
  String get gitConfigurationFormRepoTextFieldHint => 'Репозиторий';

  @override
  String get gitConfigurationFormRepoTooltip =>
      'Создайте репозиторий GitHub и введите его имя';

  @override
  String get gitConfigurationFormOwnerTextFieldHint => 'Владелец';

  @override
  String get gitConfigurationFormOwnerTooltip =>
      'Введите имя пользователя GitHub';

  @override
  String get gitConfigurationFormBranchTextFieldHint => 'Ветвь';

  @override
  String get gitConfigurationFormBranchTooltip =>
      'Создайте ветку в своем репозитории и введите здесь её имя';

  @override
  String get gitConfigurationFormFileNameTextFieldHint => 'Имя файла';

  @override
  String get gitConfigurationFormFileTooltip =>
      'Создайте [your repo]/[your brunch]/[file_name ] и введите [file_name]';

  @override
  String get gitConfigurationFormConfirmationMessageDeleteTitle =>
      'Предупреждение';

  @override
  String get gitConfigurationFormConfirmationMessageDeleteMessage =>
      'Вы уверены, что хотите удалить конфигурацию с устройства?';

  @override
  String get googleDriveConfigurationScreenTitle => 'Настройка синхронизации';

  @override
  String get googleDriveConfigurationScreenDescription =>
      'Заполните форму для настройки синхронизации через Google Drive API';

  @override
  String get googleDriveConfigurationScreenFileNameTextFieldHint => 'Имя файла';

  @override
  String get googleDriveConfigurationScreenFileNameTooltip =>
      'Имя файла для синхронизации';

  @override
  String get googleDriveConfigurationScreenConfirmationMessageDeleteTitle =>
      'Предупреждение';

  @override
  String get googleDriveConfigurationScreenConfirmationMessageDeleteMessage =>
      'Настройка синхронизации';

  @override
  String get settingsScreenTitle => 'Настройки';

  @override
  String get settingsScreenRemoteConfigurationItem => 'Настройка синхронизации';

  @override
  String get settingsScreenDeveloperSettingsItem => 'Настройки разработчика';

  @override
  String get settingsScreenLogoutItem => 'Выход';

  @override
  String get developerSettingsScreenTitle => 'Настройки разработчика';

  @override
  String get developerSettingsScreenProxyLabel => 'Прокси';

  @override
  String get developerSettingsScreenOtherLabel => 'Другое';

  @override
  String get developerSettingsScreenOshowRawErrorsLabel =>
      'Показать необработанные ошибки';

  @override
  String get developerSettingsScreenOshowRawErrorsDescription =>
      'Если `true`, будут показаны уродливые, но информативные ошибки.';

  @override
  String get developerSettingsScreenProxyFormProxyLabel => 'Прокси:';

  @override
  String get developerSettingsScreenProxyFormPortLabel => 'Порт:';
}
