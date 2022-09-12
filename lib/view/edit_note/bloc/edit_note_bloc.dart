import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/domain/gateway.dart';
import 'package:pwd/domain/model/note_item.dart';

part 'edit_note_state.dart';
part 'edit_note_event.dart';

class EditNoteBloc extends Bloc<EditNoteEvent, EditNoteState> {
  final NoteItem? note;
  final Gateway gateway;
  // StreamSubscription? dataStreamSubscription;

  EditNotePageData get data => state.data;

  EditNoteBloc({
    required this.note,
    required this.gateway,
  }) : super(
          EditNoteState.common(
            data: EditNotePageData.initial(),
          ),
        ) {
    _setupHandlers();
    add(const EditNoteEvent.start());
  }

  // @override
  // Future<void> close() {
  //   dataStreamSubscription?.cancel();
  //   return super.close();
  // }

  void _setupHandlers() {
    on<StartEvent>(_onStartEvent);
    on<SaveEvent>(_onSaveEvent);
  }

  // void _setupSubscriptions() {
  //   dataStreamSubscription = gateway.noteStream.listen((note) {});
  // }

  void _onStartEvent(
    StartEvent event,
    Emitter<EditNoteState> emit,
  ) async {
    emit(EditNoteState.loading(data: data));

    final newNote = note ?? gateway.newNoteItem();

    emit(
      EditNoteState.common(
        data: data.copyWith(
          noteItem: newNote,
        ),
      ),
    );
  }


    void _onSaveEvent(
    SaveEvent event,
    Emitter<EditNoteState> emit,
  ) async {
    // gateway.updateNote(note)
  }
}
