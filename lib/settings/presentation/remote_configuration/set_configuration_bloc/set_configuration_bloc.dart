import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/support/optional_box.dart';
import 'package:pwd/settings/domain/add_configurations_usecase.dart';
import 'package:pwd/settings/domain/remove_configurations_usecase.dart';

import 'set_configuration_bloc_data.dart';
import 'set_configuration_bloc_event.dart';
import 'set_configuration_bloc_state.dart';

final class SetConfigurationBloc
    extends Bloc<SetConfigurationBlocEvent, SetConfigurationBlocState> {
  final RemoteConfigurationProvider configurationProvider;
  final AddConfigurationsUsecase addConfigurationsUsecase;
  final RemoveConfigurationsUsecase removeConfigurationsUsecase;

  SetConfigurationBlocData get data => state.data;

  SetConfigurationBloc({
    required String? configId,
    required this.configurationProvider,
    required this.addConfigurationsUsecase,
    required this.removeConfigurationsUsecase,
  }) : super(
          SetConfigurationBlocState.common(
            data: SetConfigurationBlocData.initial(configId: configId),
          ),
        ) {
    _setupHandlers();

    add(const SetConfigurationBlocEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<NewConfigurationEvent>(_onNewConfigurationEvent);
    on<DeleteConfigurationEvent>(_onDeleteConfigurationEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<SetConfigurationBlocState> emit,
  ) async {
    try {
      final configId = data.configId.data;
      if (configId != null) {
        assert(configId.isNotEmpty, 'Config ID is empty. Impossible case');
        if (configId.isEmpty) {
          return;
        }

        final config =
            configurationProvider.currentConfiguration.withId(configId);

        assert(config != null, 'Config is null. Impossible case');
        if (config == null) {
          return;
        }

        emit(
          SetConfigurationBlocState.common(
            data: data.copyWith(
              config: OptionalBox(config),
            ),
          ),
        );
      }
    } catch (e) {
      emit(SetConfigurationBlocState.error(e: e, data: data));
    }
  }

  void _onNewConfigurationEvent(
    NewConfigurationEvent event,
    Emitter<SetConfigurationBlocState> emit,
  ) async {
    try {
      emit(SetConfigurationBlocState.loading(data: data));

      await addConfigurationsUsecase.execute(event.configuration);

      emit(
        SetConfigurationBlocState.savedState(data: data),
      );
    } catch (e) {
      emit(SetConfigurationBlocState.error(e: e, data: data));
    }
  }

  void _onDeleteConfigurationEvent(
    DeleteConfigurationEvent event,
    Emitter<SetConfigurationBlocState> emit,
  ) async {
    try {
      final configuration = data.config.data;

      assert(configuration != null);
      if (configuration != null) {
        emit(SetConfigurationBlocState.loading(data: data));
        await removeConfigurationsUsecase.execute(configuration);

        emit(
          SetConfigurationBlocState.savedState(data: data),
        );
      } else {
        return;
      }
    } catch (e) {
      emit(SetConfigurationBlocState.error(e: e, data: data));
    }
  }
}
