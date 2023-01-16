import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/pin_repository.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';

part 'remote_storage_settings_page_state.dart';
part 'remote_storage_settings_page_event.dart';

class RemoteStorageSettingsPageBloc extends Bloc<RemoteStorageSettingsPageEvent,
    RemoteStorageSettingsPageState> {
  final PinRepository pinRepository;
  final RemoteStorageConfigurationProvider remoteStorageConfigurationProvider;
  RemoteStorageConfiguration get data => state.data;

  RemoteStorageSettingsPageBloc({
    required this.pinRepository,
    required this.remoteStorageConfigurationProvider,
  }) : super(
          const RemoteStorageSettingsPageState.common(
            data: RemoteStorageConfiguration.empty(),
          ),
        ) {
    _setupHandlers();
    add(const RemoteStorageSettingsPageEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<DropEvent>(_onDrop);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<RemoteStorageSettingsPageState> emit,
  ) async {
    try {
      emit(RemoteStorageSettingsPageState.loading(data: data));

      final configuration =
          await remoteStorageConfigurationProvider.configuration;

      emit(RemoteStorageSettingsPageState.common(data: configuration));
    } catch (e) {
      emit(RemoteStorageSettingsPageState.error(data: data, error: e));
    }
  }

  void _onDrop(
    DropEvent event,
    Emitter<RemoteStorageSettingsPageState> emit,
  ) async {
    emit(RemoteStorageSettingsPageState.loading(data: data));

    await remoteStorageConfigurationProvider.dropConfiguration();
    await pinRepository.dropPin();

    emit(RemoteStorageSettingsPageState.didLogout(data: data));
  }
}
