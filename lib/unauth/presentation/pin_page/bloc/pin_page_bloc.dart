import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/base_pin.dart';
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

    // add(const PinPageBlocEvent.initial());
  }

  void _setupHandlers() {
    // on<InitialEvent>(_onInitialEvent);
    on<LoginEvent>(_onLoginEvent);
  }

  // void _onInitialEvent(
  //   InitialEvent event,
  //   Emitter<PinPageBlocState> emit,
  // ) async {
  //   final remoteConfig =
  //       await remoteStorageConfigurationProvider.currentConfiguration;

  //   if (remoteConfig is RemoteStorageConfigurationEmpty) {
  //     emit(PinPageBlocState.shouldFillConfiguration(data: data));
  //   } else {
  //     emit(PinPageBlocState.shouldEnterThePin(data: data));
  //   }
  // }

  void _onLoginEvent(
    LoginEvent event,
    Emitter<PinPageBlocState> emit,
  ) async {
    emit(PinPageBlocState.loading(data: data));

    await pinUsecase.setPin(
      Pin(
        pin: hashUsecase.pinHash(event.pin),
        pinSha512: hashUsecase.pinHash512(event.pin),
      ),
    );

    emit(PinPageBlocState.didLogin(data: data));
  }
}
