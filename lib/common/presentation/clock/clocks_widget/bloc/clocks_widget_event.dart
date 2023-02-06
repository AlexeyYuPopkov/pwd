part of 'clocks_widget_bloc.dart';

abstract class ClocksWidgetEvent extends Equatable {
  const ClocksWidgetEvent();

  const factory ClocksWidgetEvent.initial() = InitialEvent;

  const factory ClocksWidgetEvent.addClock({
    required ClockModel parameters,
  }) = AddClockEvent;

  @override
  List<Object?> get props => const [];
}

class InitialEvent extends ClocksWidgetEvent {
  const InitialEvent();
}

class AddClockEvent extends ClocksWidgetEvent {
  final ClockModel parameters;
  const AddClockEvent({required this.parameters});
}
