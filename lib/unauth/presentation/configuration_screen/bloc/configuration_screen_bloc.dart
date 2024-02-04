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
    on<SetRemoteStorageConfigurationEvent>(
        _onSetRemoteStorageConfigurationEvent);
  }

  void _onSetRemoteStorageConfigurationEvent(
    SetRemoteStorageConfigurationEvent event,
    Emitter<ConfigurationScreenState> emit,
  ) async {
    try {
      emit(ConfigurationScreenState.loading(data: data));
      final git = RemoteStorageConfiguration.git(
        token: event.token,
        repo: event.repo,
        owner: event.owner,
        branch: event.branch,
        fileName: event.fileName,
      );

      await remoteStorageConfigurationProvider.setConfiguration(
        RemoteStorageConfigurations(
          configurations: [git],
        ),
      );

      shouldCreateRemoteStorageFileUsecase.setFlag(event.needsCreateNewFile);

      emit(ConfigurationScreenState.saved(data: data));
    } catch (e) {
      emit(ConfigurationScreenState.error(data: data, e: e));
    }
  }
}
