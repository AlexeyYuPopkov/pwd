import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';

import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

import 'google_drive_notes_list_data.dart';
import 'google_drive_notes_list_event.dart';
import 'google_drive_notes_list_state.dart';

final class GoogleDriveNotesListBloc
    extends Bloc<GoogleDriveNotesListEvent, GoogleDriveNotesListState> {
  GoogleDriveNotesListData get data => state.data;

  final RemoteConfiguration configuration;
  final NotesProviderUsecase notesProviderUsecase;
  final SyncUsecase syncUsecase;

  GoogleDriveNotesListBloc({
    required this.configuration,
    required this.notesProviderUsecase,
    required this.syncUsecase,
  }) : super(
          InitialState(
            data: GoogleDriveNotesListData.initial(),
          ),
        ) {
    _setupHandlers();

    add(const GoogleDriveNotesListEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<SyncEvent>(_onSyncEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<GoogleDriveNotesListState> emit,
  ) async {
    try {
      emit(GoogleDriveNotesListState.loading(data: data));

      final notes = await notesProviderUsecase.readNotes(
        configuration: configuration,
      );

      emit(
        GoogleDriveNotesListState.common(
          data: data.copyWith(notes: notes),
        ),
      );

      add(const GoogleDriveNotesListEvent.sync());
    } catch (e) {
      emit(GoogleDriveNotesListState.error(data: data, e: e));
    }
  }

  void _onSyncEvent(
    SyncEvent event,
    Emitter<GoogleDriveNotesListState> emit,
  ) async {
    try {
      emit(GoogleDriveNotesListState.loading(data: data));

      await syncUsecase.execute(configuration: configuration);
      final notes = await notesProviderUsecase.readNotes(
        configuration: configuration,
      );

      emit(
        GoogleDriveNotesListState.common(
          data: data.copyWith(notes: notes),
        ),
      );
    } catch (e) {
      emit(GoogleDriveNotesListState.error(data: data, e: e));
    }
  }
}
