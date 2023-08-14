import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pwd/common/domain/model/clock_model.dart';
import 'package:pwd/common/domain/usecases/clock_usecase.dart';

part 'clocks_widget_event.dart';
part 'clocks_widget_state.dart';

class ClocksWidgetBloc extends Bloc<ClocksWidgetEvent, ClocksWidgetState> {
  final ClockUsecase clockUsecase;

  late final timerStream = Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  ).asBroadcastStream();

  ClocksWidgetBloc({
    required this.clockUsecase,
  }) : super(
          ClocksWidgetState.common(
            data: NotePageData.initial(),
          ),
        ) {
    _setupHandlers();
    add(const ClocksWidgetEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<ToggleEditingEvent>(_onToggleEditingEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<AddClockEvent>(_onAddClockEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<ClocksWidgetState> emit,
  ) async {
    final clocks = await clockUsecase.getClocks();

    emit(
      ClocksWidgetState.common(
        data: state.data.copyWith(parameters: clocks),
      ),
    );
  }

  void _onAddClockEvent(
    AddClockEvent event,
    Emitter<ClocksWidgetState> emit,
  ) async {
    final clocks = await clockUsecase.byAdding(event.parameters);

    emit(
      ClocksWidgetState.common(
        data: state.data.copyWith(
          parameters: clocks,
        ),
      ),
    );
  }

  void _onToggleEditingEvent(
    ToggleEditingEvent event,
    Emitter<ClocksWidgetState> emit,
  ) {
    if (state is! EditingState) {
      emit(
        ClocksWidgetState.editing(data: state.data),
      );
    } else {
      emit(
        ClocksWidgetState.common(data: state.data),
      );
    }
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
