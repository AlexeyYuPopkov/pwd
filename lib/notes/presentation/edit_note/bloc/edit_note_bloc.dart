import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/support/optional_box.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/note_item_content.dart';
import 'package:pwd/notes/domain/usecases/delete_note_usecase.dart';
import 'package:pwd/notes/domain/usecases/read_note_usecase.dart';
import 'package:pwd/notes/domain/usecases/read_notes_usecase.dart';
import 'package:pwd/notes/domain/usecases/update_note_usecase.dart';
import 'package:pwd/notes/presentation/edit_note/bloc/edit_note_page_data.dart';

part 'edit_note_state.dart';
part 'edit_note_event.dart';

final class EditNoteBloc extends Bloc<EditNoteEvent, EditNoteState> {
  final EditNoteScreenInput input;

  final ReadNoteUsecase readNoteUsecase;
  final ReadNotesUsecase readNotesUsecase;
  final UpdateNoteUsecase updateNoteUsecase;
  final DeleteNoteUsecase deleteNoteUsecase;
  EditNotePageData get data => state.data;

  EditNoteBloc({
    required this.input,
    required this.readNoteUsecase,
    required this.readNotesUsecase,
    required this.updateNoteUsecase,
    required this.deleteNoteUsecase,
  }) : super(
          EditNoteState.common(
            data: EditNotePageData.initial(),
          ),
        ) {
    _setupHandlers();
    add(const EditNoteEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<SaveEvent>(_onSaveEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<EditNoteState> emit,
  ) async {
    try {
      final theInput = input;
      switch (theInput) {
        case EditNoteScreenInputCreate():
          emit(
            EditNoteState.common(
              data: data.copyWith(
                note: OptionalBox(NewNoteItem()),
              ),
            ),
          );
          break;
        case EditNoteScreenInputUpdate():
          emit(EditNoteState.loading(data: data));

          final note = await readNoteUsecase.execute(
            configId: input.configId,
            noteId: theInput.noteId,
          );

          emit(
            EditNoteState.common(
              data: data.copyWith(
                note: OptionalBox(note),
              ),
            ),
          );
          break;
      }
    } catch (e) {
      emit(EditNoteState.error(e: e, data: data));
    }
  }

  void _onSaveEvent(
    SaveEvent event,
    Emitter<EditNoteState> emit,
  ) async {
    try {
      final noteItem = data.note.data?.copyWith(
        content: NoteContent.fromText(event.content),
      );

      assert(noteItem != null);

      if (noteItem == null) {
        return;
      }

      emit(EditNoteState.loading(data: data));

      await updateNoteUsecase.execute(
        noteItem,
        configurationId: input.configId,
      );

      emit(
        EditNoteState.didSave(
          data: data.copyWith(note: OptionalBox(noteItem)),
        ),
      );
    } catch (e) {
      emit(EditNoteState.error(data: state.data, e: e));
    }
  }

  void _onDeleteEvent(
    DeleteEvent event,
    Emitter<EditNoteState> emit,
  ) async {
    final theInput = input;
    switch (theInput) {
      case EditNoteScreenInputCreate():
        break;
      case EditNoteScreenInputUpdate():
        try {
          emit(EditNoteState.loading(data: data));

          await deleteNoteUsecase.execute(
            id: theInput.noteId,
            configurationId: theInput.configId,
          );

          emit(EditNoteState.didDelete(data: data));
        } catch (e) {
          emit(EditNoteState.error(data: state.data, e: e));
        }
        break;
    }
  }
}
