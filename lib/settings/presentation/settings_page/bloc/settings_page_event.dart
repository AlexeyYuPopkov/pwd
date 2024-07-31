part of 'settings_page_bloc.dart';

sealed class SettingsPageEvent extends Equatable {
  const SettingsPageEvent();

  const factory SettingsPageEvent.logout() = LogoutEvent;

  @override
  List<Object?> get props => const [];
}

final class LogoutEvent extends SettingsPageEvent {
  const LogoutEvent();
}
