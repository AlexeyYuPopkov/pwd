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
          NotePageState.notSynced(
            data: NotePageData.initial(),
          ),
        ) {
    _setupHandlers();

    subscription = noteStream.listen(
      (notes) {
        add(
          NotePageEvent.newData(notes: notes),
        );
      },
    );
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }

  void _setupHandlers() {
    on<NewDataEvent>(_onNewDataEvent);
    on<RefreshDataEvent>(_onRefreshDataEvent);
    on<ShouldUpdateNoteItemEvent>(_onShouldUpdateNoteItemEvent);
    on<SyncEvent>(_onSyncEvent);
  }

  void _onNewDataEvent(
    NewDataEvent event,
    Emitter<NotePageState> emit,
  ) async {
    emit(
      NotePageState.notSynced(
        data: state.data.copyWith(notes: event.notes),
      ),
    );
  }

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

  void _onShouldUpdateNoteItemEvent(
    ShouldUpdateNoteItemEvent event,
    Emitter<NotePageState> emit,
  ) async {
    try {
      emit(NotePageState.loading(data: state.data));
      await notesProviderUsecase.updateNoteItem(event.noteItem);
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

      await syncDataUsecase.getDb();

      emit(NotePageState.common(data: state.data));
    } catch (e) {
      emit(NotePageState.error(data: state.data, error: e));
    }
  }
}
