part of 'developer_settings_page_bloc.dart';

abstract class DeveloperSettingsPageEvent extends Equatable {
  const DeveloperSettingsPageEvent();

  const factory DeveloperSettingsPageEvent.initial() = InitialEvent;

  const factory DeveloperSettingsPageEvent.save({
    required String? proxy,
    required String? port,
  }) = SaveEvent;

  @override
  List<Object?> get props => const [];
}

class InitialEvent extends DeveloperSettingsPageEvent {
  const InitialEvent();
}

class SaveEvent extends DeveloperSettingsPageEvent {
  final String? proxy;
  final String? port;

  const SaveEvent({
    required this.proxy,
    required this.port,
  });
}
