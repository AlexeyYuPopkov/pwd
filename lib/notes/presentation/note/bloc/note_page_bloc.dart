import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/notes/domain/gateway.dart';
import 'package:pwd/notes/domain/model/note.dart';
import 'package:pwd/notes/domain/model/note_impl.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:uuid/uuid.dart';

part 'note_page_event.dart';
part 'note_page_state.dart';

class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
  final Gateway gateway;
  StreamSubscription? subscription;

  final Stream<Note> noteStream;

  NotePageBloc({
    required this.gateway,
    required this.noteStream,
  }) : super(
          NotePageState.common(
            data: NotePageData.initial(),
          ),
        ) {
    _setupHandlers();

    subscription = noteStream.listen(
      (note) {
        add(
          NotePageEvent.newData(note: note),
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
    on<ShouldUpdateNoteItemEvent>(_onShouldUpdateNoteItemEvent);
  }

  void _onNewDataEvent(
    NewDataEvent event,
    Emitter<NotePageState> emit,
  ) async {
    emit(
      NotePageState.common(
        data: state.data.copyWith(note: event.note),
      ),
    );
  }

  void _onShouldUpdateNoteItemEvent(
    ShouldUpdateNoteItemEvent event,
    Emitter<NotePageState> emit,
  ) async {
    emit(NotePageState.loadingState(data: state.data));

    final oldValue = state.data.note;

    final id = oldValue is EmptyNote ? const Uuid().v1() : oldValue.id;

    var notes = [...oldValue.notes];

    notes.removeWhere(
      (e) => e.id == event.noteItem.id,
    );

    notes.add(
      event.noteItem,
    );

    final noteImpl = NoteImpl(id: id, notes: notes);
    await gateway.updateNote(noteImpl);
  }
}
