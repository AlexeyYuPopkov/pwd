import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecase.dart';

part 'edit_note_state.dart';
part 'edit_note_event.dart';

class EditNoteBloc extends Bloc<EditNoteEvent, EditNoteState> {
  final NotesProviderUsecase notesProviderUsecase;
  final SyncDataUsecase syncDataUsecase;
  EditNotePageData get data => state.data;

  EditNoteBloc({
    required this.notesProviderUsecase,
    required this.syncDataUsecase,
    required NoteItem noteItem,
  }) : super(
          EditNoteState.common(
            data: EditNotePageData(noteItem: noteItem),
          ),
        ) {
    _setupHandlers();
  }

  void _setupHandlers() {
    on<SaveEvent>(_onSaveEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  void _onSaveEvent(
    SaveEvent event,
    Emitter<EditNoteState> emit,
  ) async {
    try {
      emit(EditNoteState.loading(data: data));

      final noteItem = NoteItem.updatedItem(
        id: data.noteItem.id,
        title: event.title,
        description: event.description,
        content: event.content,
      );

      await notesProviderUsecase.updateNoteItem(noteItem);

      emit(
        EditNoteState.didSave(
          data: data.copyWith(noteItem: noteItem),
        ),
      );
    } catch (e) {
      emit(EditNoteState.error(data: state.data, error: e));
    }
  }

  void _onDeleteEvent(
    DeleteEvent event,
    Emitter<EditNoteState> emit,
  ) async {
    try {
      emit(EditNoteState.loading(data: data));

      await notesProviderUsecase.deleteNoteItem(data.noteItem);
      await syncDataUsecase.updateRemote();
      emit(EditNoteState.didDelete(data: data));
    } catch (e) {
      emit(EditNoteState.error(data: state.data, error: e));
    }
  }
}
