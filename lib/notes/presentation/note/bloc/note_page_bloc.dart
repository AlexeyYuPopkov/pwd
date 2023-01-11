import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/notes_provider_impl.dart';

part 'note_page_event.dart';
part 'note_page_state.dart';

class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
  final NotesProvider gateway;
  StreamSubscription? subscription;

  Stream<List<NoteItem>> get noteStream => gateway.noteStream;

  NotePageBloc({
    required this.gateway,
  }) : super(
          NotePageState.common(
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
    on<ShouldUpdateNoteItemEvent>(_onShouldUpdateNoteItemEvent);
  }

  void _onNewDataEvent(
    NewDataEvent event,
    Emitter<NotePageState> emit,
  ) async {
    emit(
      NotePageState.common(
        data: state.data.copyWith(notes: event.notes),
      ),
    );
  }

  void _onShouldUpdateNoteItemEvent(
    ShouldUpdateNoteItemEvent event,
    Emitter<NotePageState> emit,
  ) async {
    emit(NotePageState.loadingState(data: state.data));
    await gateway.updateNoteItem(event.noteItem);
  }
}
