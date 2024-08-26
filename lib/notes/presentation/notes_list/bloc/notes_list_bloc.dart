import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/support/optional_box.dart';
import 'package:pwd/notes/domain/model/db_error.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/read_notes_usecase.dart';

import 'package:pwd/notes/domain/usecases/sync_usecase.dart';
import 'package:rxdart/rxdart.dart';

import 'notes_list_data.dart';
import 'notes_list_event.dart';
import 'notes_list_state.dart';

final class NotesListBloc extends Bloc<NotesListEvent, NotesListState> {
  NotesListData get data => state.data;

  final String? _configId;

  final RemoteConfigurationProvider remoteConfigurationProvider;
  final ReadNotesUsecase readNotesUsecase;
  final SyncUsecase syncUsecase;

  late final StreamSubscription<RealmLocalRepositoryNotification?>
      changesSubscription;

  NotesListBloc({
    required String? configId,
    required this.remoteConfigurationProvider,
    required this.readNotesUsecase,
    required this.syncUsecase,
  })  : _configId = configId,
        super(
          InitialState(
            data: NotesListData.initial(),
          ),
        ) {
    _setupHandlers();
    _createSubscriptions();

    add(const NotesListEvent.initial());
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
            const NotesListEvent.reloadLocally(),
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
    Emitter<NotesListState> emit,
  ) async {
    try {
      final config = await _getConfigurationOrThrow();

      final notes = await readNotesUsecase.execute(
        configuration: config,
      );

      emit(
        NotesListState.common(
          data: data.copyWith(
            configBox: OptionalBox(config),
            notes: notes,
          ),
        ),
      );

      add(const NotesListEvent.sync(force: false));
    } catch (e) {
      emit(NotesListState.error(data: data, e: e));
    }
  }

  void _onSyncEvent(
    SyncEvent event,
    Emitter<NotesListState> emit,
  ) async {
    try {
      if (data.notes.isNotEmpty) {
        emit(NotesListState.syncLoading(data: data));
      }

      final config = await _getConfigurationOrThrow();

      await syncUsecase.execute(
        configuration: config,
        force: event.force,
      );

      final notes = await readNotesUsecase.execute(
        configuration: config,
      );

      emit(
        NotesListState.common(
          data: data.copyWith(notes: notes),
        ),
      );
    } catch (e) {
      emit(NotesListState.error(data: data, e: e));
    }
  }

  void _onReloadLocallyEvent(
    ReloadLocallyEvent event,
    Emitter<NotesListState> emit,
  ) async {
    try {
      emit(NotesListState.loading(data: data));

      final config = await _getConfigurationOrThrow();

      final notes = await readNotesUsecase.execute(
        configuration: config,
      );

      emit(
        NotesListState.common(
          data: data.copyWith(notes: notes),
        ),
      );
    } catch (e) {
      emit(NotesListState.error(data: data, e: e));
    }
  }

  Future<RemoteConfiguration> _getConfigurationOrThrow() async {
    final configs =
        await remoteConfigurationProvider.readCurrentConfiguration();
    final config = configs.withId(_configId ?? '');

    if (config == null) {
      throw const DbError.notFound();
    } else {
      return config;
    }
  }
}
