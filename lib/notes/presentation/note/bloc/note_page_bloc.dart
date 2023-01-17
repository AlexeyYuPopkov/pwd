import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecase.dart';

part 'note_page_event.dart';
part 'note_page_state.dart';

class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
  final NotesProviderUsecase notesProviderUsecase;
  final SyncDataUsecase syncDataUsecase;

  StreamSubscription? subscription;

  Stream<List<NoteItem>> get noteStream => notesProviderUsecase.noteStream;

  NotePageBloc({
    required this.notesProviderUsecase,
    required this.syncDataUsecase,
  }) : super(
          NotePageState.common(
            data: NotePageData.initial(),
          ),
        ) {
    _setupHandlers();

    subscription = noteStream.listen(
      (notes) {
        add(NotePageEvent.newData(notes: notes));
      },
      onError: (e) => add(NotePageEvent.error(e)),
      cancelOnError: false,
    );

    _initialActions();
  }

  void _initialActions() async {
    await notesProviderUsecase.readNotes();

    add(const NotePageEvent.sync());
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }

  void _setupHandlers() {
    on<NewDataEvent>(_onNewDataEvent);
    on<ErrorEvent>(_onErrorEvent);
    on<RefreshDataEvent>(_onRefreshDataEvent);
    on<ShouldSyncEvent>(_onShouldSyncEvent);
    on<SyncEvent>(_onSyncEvent);
  }

  void _onNewDataEvent(
    NewDataEvent event,
    Emitter<NotePageState> emit,
  ) {
    final newData = state.data.copyWith(notes: event.notes);

    if (state is DidSyncState) {
      emit(NotePageState.didSync(data: newData));
    } else {
      emit(NotePageState.common(data: newData));
    }
  }

  void _onErrorEvent(
    ErrorEvent event,
    Emitter<NotePageState> emit,
  ) =>
      emit(NotePageState.error(data: state.data, error: event.error));

  void _onRefreshDataEvent(
    RefreshDataEvent event,
    Emitter<NotePageState> emit,
  ) async {
    try {
      emit(NotePageState.loading(data: state.data));
      await notesProviderUsecase.readNotes();
    } catch (e) {
      emit(NotePageState.error(data: state.data, error: e));
    }
  }

  void _onShouldSyncEvent(
    ShouldSyncEvent event,
    Emitter<NotePageState> emit,
  ) async {
    try {
      emit(NotePageState.common(data: state.data));
    } catch (e) {
      emit(NotePageState.error(data: state.data, error: e));
    }
  }

  void _onSyncEvent(
    SyncEvent event,
    Emitter<NotePageState> emit,
  ) async {
    try {
      emit(NotePageState.loading(data: state.data));

      await syncDataUsecase.sync();

      emit(NotePageState.didSync(data: state.data));
    } catch (e) {
      emit(NotePageState.error(data: state.data, error: e));
      add(const NotePageEvent.refresh());
    }
  }
}
