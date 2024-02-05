import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';

import 'configuration_screen_data.dart';
import 'configuration_screen_event.dart';
import 'configuration_screen_state.dart';

final class ConfigurationScreenBloc
    extends Bloc<ConfigurationScreenEvent, ConfigurationScreenState> {
  final RemoteStorageConfigurationProvider remoteStorageConfigurationProvider;
  final ShouldCreateRemoteStorageFileUsecase
      shouldCreateRemoteStorageFileUsecase;

  ConfigurationScreenData get data => state.data;

  ConfigurationScreenBloc({
    required this.remoteStorageConfigurationProvider,
    required this.shouldCreateRemoteStorageFileUsecase,
  }) : super(
          ConfigurationScreenState.common(
            data: ConfigurationScreenData.initial(),
          ),
        ) {
    _setupHandlers();
  }

  void _setupHandlers() {
    on<ToggleConfigurationEvent>(_onToggleConfigurationEvent);
    on<SetGitConfigurationEvent>(_onSetGitConfigurationEventEvent);
    on<SetGoogleDriveConfigurationEvent>(_onSetGoogleDriveConfigurationEvent);
    on<NextEvent>(_onNextEvent);
  }

  void _onToggleConfigurationEvent(
    ToggleConfigurationEvent event,
    Emitter<ConfigurationScreenState> emit,
  ) {
    if (event.isOn) {
      emit(ConfigurationScreenState.shouldSetup(data: data, type: event.type));
    } else {
      switch (event.type) {
        case ConfigurationType.git:
          emit(
            ConfigurationScreenState.common(
              data: data.copyWith(
                git: ConfigurationScreenDataGitBox.initial(),
              ),
            ),
          );
          break;
        case ConfigurationType.googleDrive:
          emit(
            ConfigurationScreenState.common(
              data: data.copyWith(
                googleDrive: ConfigurationScreenDataGoogleDriveBox.initial(),
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
            git: ConfigurationScreenDataGitBox(
              git: ConfigurationScreenDataGit(
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
            googleDrive: ConfigurationScreenDataGoogleDriveBox(
              googleDrive: event.configuration,
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

      final git = data.git.git;
      final googleDrive = data.googleDrive.googleDrive;

      final configurations = [
        if (googleDrive != null) googleDrive,
        if (git != null) git.configuration,
      ];

      RemoteStorageConfigurations(configurations: configurations);

      await remoteStorageConfigurationProvider.setConfigurations(
        RemoteStorageConfigurations(configurations: configurations),
      );

      if (git != null) {
        shouldCreateRemoteStorageFileUsecase.setFlag(git.shouldCreateNewFile);
      }

      emit(ConfigurationScreenState.common(data: data));
    } catch (e) {
      emit(ConfigurationScreenState.error(data: data, e: e));
    }
  }
}
