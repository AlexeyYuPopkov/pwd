part of 'settings_page_bloc.dart';

abstract class SettingsPageEvent extends Equatable {
  const SettingsPageEvent();

  const factory SettingsPageEvent.push() = PushEvent;

  @override
  List<Object?> get props => const [];
}

class PushEvent extends SettingsPageEvent {
  const PushEvent();
}
