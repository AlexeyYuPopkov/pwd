part of 'clock_settings_page_bloc.dart';

abstract class ClockSettingsPageState extends Equatable {
  final ClockSettingsPageData data;

  const ClockSettingsPageState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory ClockSettingsPageState.common({
    required ClockSettingsPageData data,
  }) = CommonState;

  const factory ClockSettingsPageState.didAddClock({
    required ClockSettingsPageData data,
  }) = DidAddClockState;
}

class CommonState extends ClockSettingsPageState {
  const CommonState({required super.data});
}

class DidAddClockState extends ClockSettingsPageState {
  const DidAddClockState({required super.data});
}

// Data
class ClockSettingsPageData extends Equatable {
  const ClockSettingsPageData._();

  const factory ClockSettingsPageData.initial() = ClockSettingsPageData._;

  @override
  List<Object?> get props => const [];
}
