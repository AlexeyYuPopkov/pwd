import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';

part 'pin_page_bloc_state.dart';
part 'pin_page_bloc_event.dart';

final class PinPageBloc extends Bloc<PinPageBlocEvent, PinPageBlocState> {
  final PinUsecase pinUsecase;
  final HashUsecase hashUsecase;

  PinPageBlocData get data => state.data;

  PinPageBloc({
    required this.pinUsecase,
    required this.hashUsecase,
  }) : super(
          const PinPageBlocState.initializing(
            data: PinPageBlocData(),
          ),
        ) {
    _setupHandlers();
  }

  void _setupHandlers() {
    on<LoginEvent>(_onLoginEvent);
  }

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
