import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pwd/notes/domain/model/note_item.dart';

part 'edit_note_state.dart';
part 'edit_note_event.dart';

class EditNoteBloc extends Bloc<EditNoteEvent, EditNoteState> {
  // StreamSubscription? dataStreamSubscription;

  EditNotePageData get data => state.data;

  EditNoteBloc({
    required NoteItem noteItem,
  }) : super(
          EditNoteState.common(
            data: EditNotePageData(noteItem: noteItem),
          ),
        ) {
    _setupHandlers();
    add(const EditNoteEvent.initial());
  }

  // @override
  // Future<void> close() {
  //   dataStreamSubscription?.cancel();
  //   return super.close();
  // }

  void _setupHandlers() {
    on<InitialEvent>(_onStartEvent);
    on<SaveEvent>(_onSaveEvent);
  }

  // void _setupSubscriptions() {
  //   dataStreamSubscription = gateway.noteStream.listen((note) {});
  // }

  void _onStartEvent(
    InitialEvent event,
    Emitter<EditNoteState> emit,
  ) async {
    // emit(EditNoteState.loading(data: data));

    // final newNote = note ?? gateway.newNoteItem();

    // emit(
    //   EditNoteState.common(
    //     data: data.copyWith(
    //       note: newNote,
    //     ),
    //   ),
    // );
  }

  void _onSaveEvent(
    SaveEvent event,
    Emitter<EditNoteState> emit,
  ) async {
    emit(EditNoteState.loading(data: data));

    // final oldValue = data.note;

    // final id = oldValue is EmptyNote ? const Uuid().v1() : oldValue.id;

    // var notes = [...oldValue.notes];

    // notes.add(
    //   NoteItem(
    //     id: const Uuid().v1(),
    //     title: NoteItemValue(style: NoteItemStyle.header, text: event.title),
    //     description:
    //         NoteItemValue(style: NoteItemStyle.body, text: event.description),
    //     content: NoteItemValue(style: NoteItemStyle.body, text: event.content),
    //     date: DateTime.now(),
    //   ),
    // );

    // final noteImpl = NoteImpl(id: id, notes: notes);
    // await gateway.updateNote(noteImpl);

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
