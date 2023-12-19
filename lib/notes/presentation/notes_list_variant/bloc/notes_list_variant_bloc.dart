import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_notes_variant_usecase.dart';

import 'notes_list_variant_bloc_data.dart';
import 'notes_list_variant_bloc_event.dart';
import 'notes_list_variant_bloc_state.dart';

class NotesListVariantBloc
    extends Bloc<NotesListVariantBlocEvent, NotesListVariantBlocState> {
  NotesListVariantBlocData get data => state.data;

  final NotesProviderUsecase notesProviderUsecase;
  final SyncNotesVariantUsecase syncNotesVariantUsecase;

  Stream<List<NoteItem>> get noteStream => notesProviderUsecase.noteStream;

  StreamSubscription? subscription;

  NotesListVariantBloc({
    required this.notesProviderUsecase,
    required this.syncNotesVariantUsecase,
  }) : super(
          InitialState(
            data: NotesListVariantBlocData.initial(),
          ),
        ) {
    _setupHandlers();

    subscription = noteStream.listen(
      (notes) {
        add(NotesListVariantBlocEvent.newNotes(notes: notes));
      },
      onError: (e) => add(NotesListVariantBlocEvent.error(e: e)),
      cancelOnError: false,
    );
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }

  void _setupHandlers() {
    on<NewNotesEvent>(_onGetNotesEventEvent);
    on<SaveNotesEvent>(_onSaveNotesEvent);
  }

  void _onGetNotesEventEvent(
    NewNotesEvent event,
    Emitter<NotesListVariantBlocState> emit,
  ) {
    emit(
      NotesListVariantBlocState.common(
        data: data.copyWith(notes: event.notes),
      ),
    );
  }

  void _onSaveNotesEvent(
    SaveNotesEvent event,
    Emitter<NotesListVariantBlocState> emit,
  ) async {
    try {
      emit(NotesListVariantBlocState.loading(data: data));

      await syncNotesVariantUsecase.call(notes: data.notes);

      emit(NotesListVariantBlocState.common(data: data));
    } catch (e) {
      emit(NotesListVariantBlocState.error(data: data, e: e));
    }
  }
}
