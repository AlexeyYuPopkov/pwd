import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';

part 'pin_page_bloc_state.dart';
part 'pin_page_bloc_event.dart';

class PinPageBloc extends Bloc<PinPageBlocEvent, PinPageBlocState> {
  final RemoteStorageConfigurationProvider remoteStorageConfigurationProvider;
  final PinUsecase pinUsecase;
  final HashUsecase hashUsecase;
  final ShouldCreateRemoteStorageFileUsecase
      shouldCreateRemoteStorageFileUsecase;

  PinPageBlocData get data => state.data;

  PinPageBloc({
    required this.remoteStorageConfigurationProvider,
    required this.pinUsecase,
    required this.hashUsecase,
    required this.shouldCreateRemoteStorageFileUsecase,
  }) : super(
          const PinPageBlocState.initializing(
            data: PinPageBlocData(),
          ),
        ) {
    _setupHandlers();

    add(const PinPageBlocEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<LoginEvent>(_onLoginEvent);
    on<SetRemoteStorageConfigurationEvent>(
      _onSetRemoteStorageConfigurationEvent,
    );
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<PinPageBlocState> emit,
  ) async {
    final remoteConfig = await remoteStorageConfigurationProvider.configuration;

    if (remoteConfig is RemoteStorageConfigurationEmpty) {
      emit(PinPageBlocState.shouldFillConfiguration(data: data));
    } else {
      emit(PinPageBlocState.shouldEnterThePin(data: data));
    }
  }

  void _onSetRemoteStorageConfigurationEvent(
    SetRemoteStorageConfigurationEvent event,
    Emitter<PinPageBlocState> emit,
  ) async {
    try {
      emit(PinPageBlocState.loading(data: data));
      final configuration = RemoteStorageConfiguration.configuration(
        token: event.token,
        repo: event.repo,
        owner: event.owner,
        branch: event.branch,
        fileName: event.fileName,
      );
      await remoteStorageConfigurationProvider.setConfiguration(configuration);

      shouldCreateRemoteStorageFileUsecase.setFlag(event.needsCreateNewFile);

      emit(PinPageBlocState.shouldEnterThePin(data: data));
    } catch (e) {
      emit(PinPageBlocState.error(data: data, error: e));
    }
  }

  void _onLoginEvent(
    LoginEvent event,
    Emitter<PinPageBlocState> emit,
  ) async {
    emit(PinPageBlocState.loading(data: data));

    final pinHash = hashUsecase.pinHash(event.pin);

    await pinUsecase.setPin(
      Pin(pin: pinHash),
    );

    emit(PinPageBlocState.didLogin(data: data));
  }
}
