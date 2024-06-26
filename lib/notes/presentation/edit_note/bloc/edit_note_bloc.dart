import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/note_item_content.dart';
import 'package:pwd/notes/domain/usecases/delete_note_usecase.dart';
import 'package:pwd/notes/domain/usecases/read_notes_usecase.dart';
import 'package:pwd/notes/domain/usecases/update_note_usecase.dart';

part 'edit_note_state.dart';
part 'edit_note_event.dart';

final class EditNoteBloc extends Bloc<EditNoteEvent, EditNoteState> {
  final RemoteConfiguration configuration;
  final ReadNotesUsecase readNotesUsecase;
  final UpdateNoteUsecase updateNoteUsecase;
  final DeleteNoteUsecase deleteNoteUsecase;
  EditNotePageData get data => state.data;

  EditNoteBloc({
    required this.configuration,
    required this.readNotesUsecase,
    required this.updateNoteUsecase,
    required this.deleteNoteUsecase,
    required BaseNoteItem noteItem,
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

      final noteItem = data.noteItem.copyWith(
        content: NoteContent.fromText(event.content),
      );

      await updateNoteUsecase.execute(
        noteItem,
        configuration: configuration,
      );

      emit(
        EditNoteState.didSave(
          data: data.copyWith(noteItem: noteItem),
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
    try {
      emit(EditNoteState.loading(data: data));

      await deleteNoteUsecase.execute(
        id: data.noteItem.id,
        configuration: configuration,
      );

      emit(EditNoteState.didDelete(data: data));
    } catch (e) {
      emit(EditNoteState.error(data: state.data, e: e));
    }
  }
}
