import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/settings/domain/add_configurations_usecase.dart';
import 'package:pwd/settings/domain/remove_configurations_usecase.dart';

import 'set_configuration_bloc_data.dart';
import 'set_configuration_bloc_event.dart';
import 'set_configuration_bloc_state.dart';

final class SetConfigurationBloc
    extends Bloc<SetConfigurationBlocEvent, SetConfigurationBlocState> {
  final AddConfigurationsUsecase addConfigurationsUsecase;
  final RemoveConfigurationsUsecase removeConfigurationsUsecase;

  SetConfigurationBlocData get data => state.data;

  SetConfigurationBloc({
    required RemoteConfiguration? initialData,
    required this.addConfigurationsUsecase,
    required this.removeConfigurationsUsecase,
  }) : super(
          SetConfigurationBlocState.common(
            data: SetConfigurationBlocData.initial(initialData: initialData),
          ),
        ) {
    _setupHandlers();
  }

  void _setupHandlers() {
    on<NewConfigurationEvent>(_onNewConfigurationEvent);
    on<DeleteConfigurationEvent>(_onDeleteConfigurationEvent);
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
      final configuration = data.initialData.data;

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
