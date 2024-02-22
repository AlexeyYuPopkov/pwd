import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/support/optional_box.dart';
import 'package:pwd/settings/domain/save_configurations_usecase.dart';

import 'configuration_screen_data.dart';
import 'configuration_screen_event.dart';
import 'configuration_screen_state.dart';

final class ConfigurationScreenBloc
    extends Bloc<ConfigurationScreenEvent, ConfigurationScreenState> {
  final RemoteStorageConfigurationProvider remoteStorageConfigurationProvider;

  final SaveConfigurationsUsecase saveConfigurationsUsecase;

  ConfigurationScreenData get data => state.data;

  ConfigurationScreenBloc({
    required this.remoteStorageConfigurationProvider,
    required this.saveConfigurationsUsecase,
  }) : super(
          ConfigurationScreenState.common(
            data: ConfigurationScreenData.initial(
              configurations: RemoteStorageConfigurations.empty(),
            ),
          ),
        ) {
    _setupHandlers();

    add(const InitialEvent());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<ToggleConfigurationEvent>(_onToggleConfigurationEvent);
    on<SetGitConfigurationEvent>(_onSetGitConfigurationEventEvent);
    on<SetGoogleDriveConfigurationEvent>(_onSetGoogleDriveConfigurationEvent);
    on<NextEvent>(_onNextEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<ConfigurationScreenState> emit,
  ) {
    final currentConfiguration =
        remoteStorageConfigurationProvider.currentConfiguration;

    emit(
      ConfigurationScreenState.common(
        data: ConfigurationScreenData.initial(
          configurations: currentConfiguration,
        ),
      ),
    );
  }

  void _onToggleConfigurationEvent(
    ToggleConfigurationEvent event,
    Emitter<ConfigurationScreenState> emit,
  ) {
    if (event.isOn) {
      final initial = remoteStorageConfigurationProvider.currentConfiguration;

      emit(
        ConfigurationScreenState.shouldSetup(
          data: data,
          type: event.type,
          configuration: initial.withType(event.type),
        ),
      );
    } else {
      switch (event.type) {
        case ConfigurationType.git:
          emit(
            ConfigurationScreenState.common(
              data: data.copyWith(
                git: OptionalBox.empty(),
              ),
            ),
          );
          break;
        case ConfigurationType.googleDrive:
          emit(
            ConfigurationScreenState.common(
              data: data.copyWith(
                googleDrive: OptionalBox.empty(),
              ),
            ),
          );
          break;
      }
    }
  }

  void _onSetGitConfigurationEventEvent(
    SetGitConfigurationEvent event,
    Emitter<ConfigurationScreenState> emit,
  ) =>
      emit(
        ConfigurationScreenState.common(
          data: data.copyWith(
            git: OptionalBox(
              ConfigurationScreenDataGit(
                configuration: event.configuration,
                shouldCreateNewFile: event.needsCreateNewFile,
              ),
            ),
          ),
        ),
      );

  void _onSetGoogleDriveConfigurationEvent(
    SetGoogleDriveConfigurationEvent event,
    Emitter<ConfigurationScreenState> emit,
  ) =>
      emit(
        ConfigurationScreenState.common(
          data: data.copyWith(
            googleDrive: OptionalBox(
              event.configuration,
            ),
          ),
        ),
      );

  void _onNextEvent(
    NextEvent event,
    Emitter<ConfigurationScreenState> emit,
  ) async {
    try {
      emit(ConfigurationScreenState.loading(data: data));

      final git = data.git.data;
      final shouldCreateNewGitFile =
          git != null ? git.shouldCreateNewFile : false;

      await saveConfigurationsUsecase.execute(
        configuration: data.createRemoteStorageConfigurations(),
        shouldCreateNewGitFile: shouldCreateNewGitFile,
      );

      emit(ConfigurationScreenState.common(data: data));
    } catch (e) {
      emit(ConfigurationScreenState.error(data: data, e: e));
    }
  }
}
