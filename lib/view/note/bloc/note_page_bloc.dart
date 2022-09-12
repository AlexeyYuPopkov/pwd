import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/domain/model/note_item.dart';

part 'note_page_state.dart';
part 'note_page_event.dart';

class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
  NotePageBloc()
      : super(
          NotePageState.initial(
            data: NotePageData.initial(),
          ),
        ) {
    _setupHandlers();
    // add(const NotePageEvent.start());
  }

  void _setupHandlers() {
    // on<StartEvent>(_onStartEvent);
    // on<LoginEvent>(_onLoginEvent);
  }

  // void _onStartEvent(
  //   StartEvent event,
  //   Emitter<NotePageState> emit,
  // ) async =>
  //     emit(NotePageState.start(data: state.data));

}
