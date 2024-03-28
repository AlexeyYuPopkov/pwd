import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pwd/common/domain/model/clock_model.dart';
import 'package:pwd/common/domain/usecases/clock_usecase.dart';

part 'clocks_widget_event.dart';
part 'clocks_widget_state.dart';

final class ClocksWidgetBloc
    extends Bloc<ClocksWidgetEvent, ClocksWidgetState> {
  final ClockUsecase clockUsecase;

  ClocksWidgetBloc({
    required this.clockUsecase,
  }) : super(
          ClocksWidgetState.common(
            data: ClocksWidgetData.initial(),
          ),
        ) {
    _setupHandlers();
    add(const ClocksWidgetEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<AddClockEvent>(_onAddClockEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<ClocksWidgetState> emit,
  ) async {
    final clocks = await clockUsecase.getClocks();

    final newData = state.data.copyWith(parameters: clocks);

    emit(
      ClocksWidgetState.common(data: newData),
    );
  }

  void _onAddClockEvent(
    AddClockEvent event,
    Emitter<ClocksWidgetState> emit,
  ) async {
    final clocks = await clockUsecase.changedWithClock(event.parameters);

    emit(
      ClocksWidgetState.common(
        data: state.data.copyWith(
          parameters: clocks,
        ),
      ),
    );
  }

  void _onDeleteEvent(
    DeleteEvent event,
    Emitter<ClocksWidgetState> emit,
  ) async {
    final clocks = await clockUsecase.byClockDeletion(event.clock);

    emit(
      ClocksWidgetState.common(data: state.data.copyWith(parameters: clocks)),
    );
  }
}
