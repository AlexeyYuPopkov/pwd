import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/app_settings.dart';
import 'package:pwd/common/domain/usecases/get_settings_usecase.dart';
import 'package:pwd/unauth/domain/usecases/login_usecase.dart';

part 'pin_page_bloc_state.dart';
part 'pin_page_bloc_event.dart';

final class PinPageBloc extends Bloc<PinPageBlocEvent, PinPageBlocState> {
  final LoginUsecase loginUsecase;
  final GetSettingsUsecase settingsUsecase;

  PinPageBlocData get data => state.data;

  PinPageBloc({
    required this.loginUsecase,
    required this.settingsUsecase,
  }) : super(
          const PinPageBlocState.initializing(
            data: PinPageBlocData.initial(),
          ),
        ) {
    _setupHandlers();
    add(const PinPageBlocEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<LoginEvent>(_onLoginEvent);
  }

  void _onLoginEvent(
    LoginEvent event,
    Emitter<PinPageBlocState> emit,
  ) async {
    try {
      emit(PinPageBlocState.loading(data: data));
      await loginUsecase.execute(event.pin);
      emit(PinPageBlocState.didLogin(data: data));
    } catch (e) {
      emit(PinPageBlocState.error(data: data, error: e));
    }
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<PinPageBlocState> emit,
  ) async {
    final settings = await settingsUsecase.execute();
    emit(
      PinPageBlocState.initializing(
        data: data.copyWith(
          enterPinKeyboardType: settings.enterPinKeyboardType,
        ),
      ),
    );
  }
}
