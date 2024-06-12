import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/settings/domain/reorder_configurations_usecase.dart';
import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/bloc/configurations_screen_state.dart';

import 'configurations_screen_data.dart';
import 'configurations_screen_event.dart';

final class ConfigurationsScreenBloc
    extends Bloc<ConfigurationsScreenEvent, ConfigurationsScreenState> {
  final RemoteConfigurationProvider remoteStorageConfigurationProvider;
  final ReorderConfigurationsUsecase reorderConfigurationsUsecase;

  late final StreamSubscription configurationSubscription;

  ConfigurationsScreenData get data => state.data;

  ConfigurationsScreenBloc({
    required this.remoteStorageConfigurationProvider,
    required this.reorderConfigurationsUsecase,
  }) : super(
          ConfigurationsScreenState.common(
            data: ConfigurationsScreenData.initial(),
          ),
        ) {
    _subscribeToStreams();
    _setupHandlers();
  }

  void _setupHandlers() {
    on<ShouldReorderEvent>(_onShouldReorderEvent);
    on<DidChangeEvent>(_onDidChangeEvent);
  }

  void _subscribeToStreams() {
    configurationSubscription =
        remoteStorageConfigurationProvider.configuration.listen(
      (e) {
        add(
          ConfigurationsScreenEvent.didChange(
            configurations: e.configurations,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    configurationSubscription.cancel();
    return super.close();
  }

  void _onShouldReorderEvent(
    ShouldReorderEvent event,
    Emitter<ConfigurationsScreenState> emit,
  ) async {
    try {
      var newIndexVar = event.newIndex;
      if (event.oldIndex < newIndexVar) {
        newIndexVar -= 1;
      }

      await reorderConfigurationsUsecase.execute(
        oldIndex: event.oldIndex,
        newIndex: newIndexVar,
      );
    } catch (e) {
      emit(ConfigurationsScreenState.error(e: e, data: data));
    }
  }

  void _onDidChangeEvent(
    DidChangeEvent event,
    Emitter<ConfigurationsScreenState> emit,
  ) =>
      emit(
        ConfigurationsScreenState.common(
          data: data.copyWith(
            items: event.configurations,
          ),
        ),
      );
}
