import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/settings/domain/sync_data_usecases.dart';

part 'settings_page_state.dart';
part 'settings_page_event.dart';

class SettingsPageBloc extends Bloc<SettingsPageEvent, SettingsPageState> {
  final SyncDataUsecases syncDataUsecases;

  EditNotePageData get data => state.data;

  SettingsPageBloc({
    required this.syncDataUsecases,
  }) : super(
          const SettingsPageState.unauth(
            data: EditNotePageData.initial(),
          ),
        ) {
    _setupHandlers();
  }

  void _setupHandlers() {
    on<PushEvent>(_onPushEvent);
  }

  void _onPushEvent(
    PushEvent event,
    Emitter<SettingsPageState> emit,
  ) async {
    try {
      emit(SettingsPageState.loading(data: data));

      await syncDataUsecases.putDb();

      emit(SettingsPageState.auth(data: data));
    } catch (e) {
      emit(SettingsPageState.error(data: data, error: e));
    }
  }
}
