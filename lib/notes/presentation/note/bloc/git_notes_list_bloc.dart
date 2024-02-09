import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_git_item_usecase.dart';

part 'git_notes_list_event.dart';
part 'git_notes_list_state.dart';

final class GitNotesListBloc
    extends Bloc<GitNotesListEvent, GitNotesListState> {
  final GitConfiguration configuration;
  final NotesProviderUsecase notesProviderUsecase;
  final SyncGitItemUsecase syncDataUsecase;
  final ShouldCreateRemoteStorageFileUsecase
      shouldCreateRemoteStorageFileUsecase;

  StreamSubscription? subscription;

  Stream<List<NoteItem>> get noteStream => notesProviderUsecase.noteStream;

  GitNotesListBloc({
    required this.configuration,
    required this.notesProviderUsecase,
    required this.syncDataUsecase,
    required this.shouldCreateRemoteStorageFileUsecase,
  }) : super(
          GitNotesListState.common(
            data: NotePageData.initial(),
          ),
        ) {
    _setupHandlers();

    subscription = noteStream.listen(
      (notes) {
        add(GitNotesListEvent.newData(notes: notes));
      },
      onError: (e) => add(GitNotesListEvent.error(e)),
      cancelOnError: false,
    );

    _initialActions();
  }

  void _initialActions() async {
    if (shouldCreateRemoteStorageFileUsecase.flag) {
      add(const GitNotesListEvent.forceCreateRemoteSyncFile());
    } else {
      await notesProviderUsecase.readNotes();

      add(const GitNotesListEvent.sync());
    }
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }

  void _setupHandlers() {
    on<ForceCreateRemoteSyncFileEvent>(_onForceCreateRemoteSyncFileEvent);
    on<NewDataEvent>(_onNewDataEvent);
    on<ErrorEvent>(_onErrorEvent);
    on<RefreshDataEvent>(_onRefreshDataEvent);
    on<ShouldSyncEvent>(_onShouldSyncEvent);
    on<SyncEvent>(_onSyncEvent);
  }

  void _onForceCreateRemoteSyncFileEvent(
    ForceCreateRemoteSyncFileEvent event,
    Emitter<GitNotesListState> emit,
  ) async {
    try {
      emit(GitNotesListState.loading(data: state.data));
      await syncDataUsecase.createOrOverrideDb(configuration: configuration);
      emit(GitNotesListState.common(data: state.data));
      _initialActions();
    } catch (e) {
      emit(GitNotesListState.error(data: state.data, error: e));
    }
  }

  void _onNewDataEvent(
    NewDataEvent event,
    Emitter<GitNotesListState> emit,
  ) {
    final newData = state.data.copyWith(notes: event.notes);

    if (state is DidSyncState) {
      emit(GitNotesListState.didSync(data: newData));
    } else {
      emit(GitNotesListState.common(data: newData));
    }
  }

  void _onErrorEvent(
    ErrorEvent event,
    Emitter<GitNotesListState> emit,
  ) =>
      emit(GitNotesListState.error(data: state.data, error: event.error));

  void _onRefreshDataEvent(
    RefreshDataEvent event,
    Emitter<GitNotesListState> emit,
  ) async {
    try {
      emit(GitNotesListState.loading(data: state.data));
      await notesProviderUsecase.readNotes();
    } catch (e) {
      emit(GitNotesListState.error(data: state.data, error: e));
    }
  }

  void _onShouldSyncEvent(
    ShouldSyncEvent event,
    Emitter<GitNotesListState> emit,
  ) async {
    try {
      emit(GitNotesListState.common(data: state.data));
    } catch (e) {
      emit(GitNotesListState.error(data: state.data, error: e));
    }
  }

  void _onSyncEvent(
    SyncEvent event,
    Emitter<GitNotesListState> emit,
  ) async {
    try {
      emit(GitNotesListState.loading(data: state.data));

      await syncDataUsecase.sync(configuration: configuration);

      emit(GitNotesListState.didSync(data: state.data));
    } catch (e) {
      emit(GitNotesListState.error(data: state.data, error: e));
      add(const GitNotesListEvent.refresh());
    }
  }
}
