import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/clock_configuration_provider.dart';
import 'package:pwd/common/domain/model/clock_model.dart';

part 'clocks_widget_event.dart';
part 'clocks_widget_state.dart';

class ClocksWidgetBloc extends Bloc<ClocksWidgetEvent, ClocksWidgetState> {
  final ClockConfigurationProvider clockConfigurationProvider;

  late final timerStream = Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  ).asBroadcastStream();

  ClocksWidgetBloc({
    required String localLabelText,
    required this.clockConfigurationProvider,
  }) : super(
          ClocksWidgetState.common(
            data: NotePageData.initial(localLabelText: localLabelText),
          ),
        ) {
    _setupHandlers();
    add(const ClocksWidgetEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<AddClockEvent>(_onAddClockEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<ClocksWidgetState> emit,
  ) async {
    final clocks = await clockConfigurationProvider.clocks;
    final hasZeroTimezoneClock = clocks
        .where(
          (e) => e.timezoneOffset == Duration.zero,
        )
        .isNotEmpty;

    emit(
      ClocksWidgetState.common(
        data: state.data.copyWith(
          parameters: [
            if (!hasZeroTimezoneClock) ...state.data.parameters,
            ...clocks,
          ],
        ),
      ),
    );
  }

  void _onAddClockEvent(
    AddClockEvent event,
    Emitter<ClocksWidgetState> emit,
  ) async {
    final clocks = [
      ...state.data.parameters,
      event.parameters,
    ];

    await clockConfigurationProvider.setClocks(clocks);

    emit(
      ClocksWidgetState.common(
        data: state.data.copyWith(
          parameters: clocks,
        ),
      ),
    );
  }
}
