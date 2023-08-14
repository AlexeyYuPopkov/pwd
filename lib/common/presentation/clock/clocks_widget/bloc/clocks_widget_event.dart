part of 'clocks_widget_bloc.dart';

abstract class ClocksWidgetEvent extends Equatable {
  const ClocksWidgetEvent();

  const factory ClocksWidgetEvent.initial() = InitialEvent;

  const factory ClocksWidgetEvent.edit() = ToggleEditingEvent;

  const factory ClocksWidgetEvent.delete({
    required ClockModel clock,
  }) = DeleteEvent;

  const factory ClocksWidgetEvent.addClock({
    required ClockModel parameters,
  }) = AddClockEvent;

  @override
  List<Object?> get props => const [];
}

class InitialEvent extends ClocksWidgetEvent {
  const InitialEvent();
}

class ToggleEditingEvent extends ClocksWidgetEvent {
  const ToggleEditingEvent();
}

class DeleteEvent extends ClocksWidgetEvent {
  final ClockModel clock;
  const DeleteEvent({required this.clock});
}

class AddClockEvent extends ClocksWidgetEvent {
  final ClockModel parameters;
  const AddClockEvent({required this.parameters});
}
