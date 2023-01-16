part of 'settings_page_bloc.dart';

abstract class SettingsPageEvent extends Equatable {
  const SettingsPageEvent();

  const factory SettingsPageEvent.logout() = LogoutEvent;

  @override
  List<Object?> get props => const [];
}

class LogoutEvent extends SettingsPageEvent {
  const LogoutEvent();
}
