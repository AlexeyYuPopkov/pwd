part of 'developer_settings_page_bloc.dart';

sealed class DeveloperSettingsPageEvent extends Equatable {
  const DeveloperSettingsPageEvent();

  const factory DeveloperSettingsPageEvent.initial() = InitialEvent;

  const factory DeveloperSettingsPageEvent.save({
    required ProxyAppConfiguration proxy,
  }) = SaveEvent;

  const factory DeveloperSettingsPageEvent.formChanged({
    required ProxyAppConfiguration proxy,
  }) = FormChangedEvent;

  const factory DeveloperSettingsPageEvent.showsRawErrorsFlagChanged({
    required bool flag,
  }) = ShowsRawErrorsFlagChangedEvent;

  @override
  List<Object?> get props => const [];
}

final class InitialEvent extends DeveloperSettingsPageEvent {
  const InitialEvent();
}

final class SaveEvent extends DeveloperSettingsPageEvent {
  final ProxyAppConfiguration proxy;

  const SaveEvent({
    required this.proxy,
  });
}

final class FormChangedEvent extends DeveloperSettingsPageEvent {
  final ProxyAppConfiguration proxy;

  const FormChangedEvent({
    required this.proxy,
  });
}

final class ShowsRawErrorsFlagChangedEvent extends DeveloperSettingsPageEvent {
  final bool flag;

  const ShowsRawErrorsFlagChangedEvent({
    required this.flag,
  });
}
