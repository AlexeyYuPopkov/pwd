import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/clock_configuration_provider.dart';
import 'package:pwd/common/domain/model/clock_model.dart';

part 'clock_settings_page_event.dart';
part 'clock_settings_page_state.dart';

class ClockSettingsPageBloc
    extends Bloc<ClockSettingsPageEvent, ClockSettingsPageState> {
  final ClockConfigurationProvider clockConfigurationProvider;

  late final timerStream = Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  ).asBroadcastStream();

  ClockSettingsPageBloc({
    required this.clockConfigurationProvider,
  }) : super(
          const ClockSettingsPageState.common(
            data: ClockSettingsPageData.initial(),
          ),
        ) {
    _setupHandlers();
  }

  void _setupHandlers() {
    on<AddClockEvent>(_onAddClockEvent);
  }

  void _onAddClockEvent(
    AddClockEvent event,
    Emitter<ClockSettingsPageState> emit,
  ) async {
    final clocks = [
      ...await clockConfigurationProvider.clocks,
      event.parameters,
    ];

    await clockConfigurationProvider.setClocks(clocks);

    emit(
      ClockSettingsPageState.didAddClock(data: state.data),
    );
  }
}
