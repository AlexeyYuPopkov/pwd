import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/read_notes_usecase.dart';

import 'package:pwd/notes/domain/usecases/sync_usecase.dart';
import 'package:rxdart/rxdart.dart';

import 'google_drive_notes_list_data.dart';
import 'google_drive_notes_list_event.dart';
import 'google_drive_notes_list_state.dart';

final class GoogleDriveNotesListBloc
    extends Bloc<GoogleDriveNotesListEvent, GoogleDriveNotesListState> {
  GoogleDriveNotesListData get data => state.data;

  final RemoteConfiguration configuration;
  final ReadNotesUsecase readNotesUsecase;
  final SyncUsecase syncUsecase;

  late final StreamSubscription<RealmLocalRepositoryNotification?>
      changesSubscription;

  GoogleDriveNotesListBloc({
    required this.configuration,
    required this.readNotesUsecase,
    required this.syncUsecase,
  }) : super(
          InitialState(
            data: GoogleDriveNotesListData.initial(),
          ),
        ) {
    _setupHandlers();
    _createSubscriptions();

    add(const GoogleDriveNotesListEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<SyncEvent>(_onSyncEvent);
    on<ReloadLocallyEvent>(_onReloadLocallyEvent);
  }

  void _createSubscriptions() {
    changesSubscription = readNotesUsecase
        .getChangesStream()
        .debounceTime(
          Durations.extralong1,
        )
        .listen(
      (e) {
        if (e != null) {
          add(
            const GoogleDriveNotesListEvent.reloadLocally(),
          );
        }
      },
    );
  }

  @override
  Future<void> close() {
    changesSubscription.cancel();
    return super.close();
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<GoogleDriveNotesListState> emit,
  ) async {
    try {
      final notes = await readNotesUsecase.execute(
        configuration: configuration,
      );

      if (notes.isNotEmpty) {
        emit(
          GoogleDriveNotesListState.common(
            data: data.copyWith(notes: notes),
          ),
        );
      }

      add(const GoogleDriveNotesListEvent.sync(force: false));
    } catch (e) {
      emit(GoogleDriveNotesListState.error(data: data, e: e));
    }
  }

  void _onSyncEvent(
    SyncEvent event,
    Emitter<GoogleDriveNotesListState> emit,
  ) async {
    try {
      if (data.notes.isNotEmpty) {
        emit(GoogleDriveNotesListState.syncLoading(data: data));
      }

      await syncUsecase.execute(
          configuration: configuration, force: event.force);
      final notes = await readNotesUsecase.execute(
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

  void _onReloadLocallyEvent(
    ReloadLocallyEvent event,
    Emitter<GoogleDriveNotesListState> emit,
  ) async {
    try {
      emit(GoogleDriveNotesListState.loading(data: data));

      final notes = await readNotesUsecase.execute(
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
