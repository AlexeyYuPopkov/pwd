import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/unauth/domain/usecases/login_usecase.dart';

part 'pin_page_bloc_state.dart';
part 'pin_page_bloc_event.dart';

final class PinPageBloc extends Bloc<PinPageBlocEvent, PinPageBlocState> {
  final LoginUsecase loginUsecase;

  PinPageBlocData get data => state.data;

  PinPageBloc({
    required this.loginUsecase,
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

    await loginUsecase.execute(event.pin);

    emit(PinPageBlocState.didLogin(data: data));
  }
}
