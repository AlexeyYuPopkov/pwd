import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pwd/notes/domain/model/note_item.dart';

part 'edit_note_state.dart';
part 'edit_note_event.dart';

class EditNoteBloc extends Bloc<EditNoteEvent, EditNoteState> {
  EditNotePageData get data => state.data;

  EditNoteBloc({
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
  }

  void _onSaveEvent(
    SaveEvent event,
    Emitter<EditNoteState> emit,
  ) async {
    emit(EditNoteState.loading(data: data));
    final noteItem = data.noteItem.copyWith(
      title: event.title,
      description: event.description,
      content: event.content,
      timestamp: data.noteItem.timestamp,
    );
    emit(
      EditNoteState.didSave(
        data: data.copyWith(
          noteItem: noteItem,
        ),
      ),
    );
  }
}
