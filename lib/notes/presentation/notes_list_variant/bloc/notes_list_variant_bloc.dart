import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notes_list_variant_bloc_data.dart';
import 'notes_list_variant_bloc_event.dart';
import 'notes_list_variant_bloc_state.dart';

class TestBloc
    extends Bloc<NotesListVariantBlocEvent, NotesListVariantBlocState> {
  NotesListVariantBlocData get data => state.data;

  TestBloc()
      : super(
          InitialState(
            data: NotesListVariantBlocData.initial(),
          ),
        ) {
    _setupHandlers();

    add(const NotesListVariantBlocEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<NotesListVariantBlocState> emit,
  ) async {
    try {
      emit(NotesListVariantBlocState.loading(data: data));

      await Future.delayed(const Duration(seconds: 2));

      emit(
        NotesListVariantBlocState.common(data: data),
      );
    } catch (e) {
      emit(NotesListVariantBlocState.error(e: e, data: data));
    }
  }
}
