import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';

part 'settings_page_state.dart';
part 'settings_page_event.dart';

class SettingsPageBloc extends Bloc<SettingsPageEvent, SettingsPageState> {
  final PinUsecase pinUsecase;
  SettingsPageData get data => state.data;

  SettingsPageBloc({
    required this.pinUsecase,
  }) : super(
          const SettingsPageState.common(
            data: SettingsPageData(),
          ),
        ) {
    _setupHandlers();
  }

  void _setupHandlers() {
    on<LogoutEvent>(_onLogoutEvent);
  }

  void _onLogoutEvent(
    LogoutEvent event,
    Emitter<SettingsPageState> emit,
  ) async {
    try {
      emit(SettingsPageState.loading(data: data));

      await pinUsecase.dropPin();

      emit(SettingsPageState.didLogout(data: data));
    } catch (e) {
      emit(SettingsPageState.error(data: data, error: e));
    }
  }
}
