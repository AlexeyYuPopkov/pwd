import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/bloc/configurations_screen_state.dart';

import 'configurations_screen_data.dart';
import 'configurations_screen_event.dart';

class ConfigurationsScreenBloc
    extends Bloc<ConfigurationsScreenEvent, ConfigurationsScreenState> {
  final RemoteConfigurationProvider remoteStorageConfigurationProvider;

  ConfigurationsScreenData get data => state.data;

  ConfigurationsScreenBloc({
    required this.remoteStorageConfigurationProvider,
  }) : super(
          ConfigurationsScreenState.common(
            data: ConfigurationsScreenData.initial(),
          ),
        ) {
    _setupHandlers();

    add(const ConfigurationsScreenEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<ConfigurationsScreenState> emit,
  ) {
    try {
      final configuration =
          remoteStorageConfigurationProvider.currentConfiguration;

      emit(
        ConfigurationsScreenState.common(
          data: data.copyInitialItemsWith(
            items: configuration.configurations,
          ),
        ),
      );
    } catch (e) {
      emit(ConfigurationsScreenState.error(e: e, data: data));
    }
  }
}
