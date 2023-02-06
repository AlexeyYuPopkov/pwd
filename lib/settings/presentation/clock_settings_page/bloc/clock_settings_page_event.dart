part of 'clock_settings_page_bloc.dart';

abstract class ClockSettingsPageEvent extends Equatable {
  const ClockSettingsPageEvent();

  const factory ClockSettingsPageEvent.addClock({
    required ClockModel parameters,
  }) = AddClockEvent;

  @override
  List<Object?> get props => const [];
}

class AddClockEvent extends ClockSettingsPageEvent {
  final ClockModel parameters;
  const AddClockEvent({required this.parameters});
}
