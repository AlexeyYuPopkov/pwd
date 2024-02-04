import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/notes_repository.dart';

part 'remote_storage_settings_page_state.dart';
part 'remote_storage_settings_page_event.dart';

class RemoteStorageSettingsPageBloc extends Bloc<RemoteStorageSettingsPageEvent,
    RemoteStorageSettingsPageState> {
  final PinUsecase pinUsecase;
  final RemoteStorageConfigurationProvider remoteStorageConfigurationProvider;
  final NotesRepository notesRepository;

  RemoteStorageConfigurations get data => state.data;

  RemoteStorageSettingsPageBloc({
    required this.pinUsecase,
    required this.remoteStorageConfigurationProvider,
    required this.notesRepository,
  }) : super(
          RemoteStorageSettingsPageState.common(
            data: RemoteStorageConfigurations.empty(),
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
          remoteStorageConfigurationProvider.currentConfiguration;

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
    await notesRepository.dropDb();
    // TODO: drop realm
    await pinUsecase.dropPin();

    emit(RemoteStorageSettingsPageState.didLogout(data: data));
  }
}
