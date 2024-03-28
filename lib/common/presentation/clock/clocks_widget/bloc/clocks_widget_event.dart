part of 'clocks_widget_bloc.dart';

sealed class ClocksWidgetEvent extends Equatable {
  const ClocksWidgetEvent();

  const factory ClocksWidgetEvent.initial() = InitialEvent;

  const factory ClocksWidgetEvent.delete({
    required ClockModel clock,
  }) = DeleteEvent;

  const factory ClocksWidgetEvent.addClock({
    required ClockModel parameters,
  }) = AddClockEvent;

  @override
  List<Object?> get props => const [];
}

final class InitialEvent extends ClocksWidgetEvent {
  const InitialEvent();
}

final class DeleteEvent extends ClocksWidgetEvent {
  final ClockModel clock;
  const DeleteEvent({required this.clock});
}

final class AddClockEvent extends ClocksWidgetEvent {
  final ClockModel parameters;
  const AddClockEvent({required this.parameters});
}
