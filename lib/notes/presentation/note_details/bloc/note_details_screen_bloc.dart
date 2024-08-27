import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/tools/reusable_isolate/reusable_isolate.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/usecases/read_note_usecase.dart';
import 'package:pwd/notes/presentation/note_details/bloc/note_details_screen_data.dart';
import 'package:pwd/notes/presentation/note_details/bloc/note_details_screen_event.dart';
import 'package:pwd/notes/presentation/note_details/bloc/note_details_screen_state.dart';

import '../note_details_screen_list_model.dart';

final class NoteDetailsScreenBloc
    extends Bloc<NoteDetailsScreenEvent, NoteDetailsScreenState> {
  late final _isTest = Platform.environment.containsKey('FLUTTER_TEST');
  final String _configId;
  final String _noteId;
  final ReadNoteUsecase readNoteUsecase;
  NoteDetailsScreenData get data => state.data;

  NoteDetailsScreenBloc({
    required String configId,
    required String noteId,
    required this.readNoteUsecase,
  })  : _configId = configId,
        _noteId = noteId,
        super(
          NoteDetailsScreenState.common(
            data: NoteDetailsScreenData.initial(),
          ),
        ) {
    _setupHandlers();

    add(const NoteDetailsScreenEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<NoteDetailsScreenState> emit,
  ) async {
    try {
      emit(NoteDetailsScreenState.loading(data: data));

      final noteItem = await readNoteUsecase.execute(
        configId: _configId,
        noteId: _noteId,
      );

      final lines = await _createModelsAsync(noteItem);

      emit(
        NoteDetailsScreenState.common(data: data.copyWith(lines: lines)),
      );
    } catch (e) {
      emit(NoteDetailsScreenState.error(e: e, data: data));
    }
  }
}

extension on NoteDetailsScreenBloc {
  Future<List<NoteDetailsScreenListModel>> _createModelsAsync(
    BaseNoteItem noteItem,
  ) async {
    if (_isTest) {
      return _createModels(noteItem) as List<NoteDetailsScreenListModel>;
    } else {
      final isolate = await ReusableIsolate.create();
      return isolate
          .performTask(
            ReusableIsolateTask.sync(
              params: noteItem,
              computation: _createModels,
            ),
          )
          .then((e) => e as List<NoteDetailsScreenListModel>);
    }
  }

  static dynamic _createModels(dynamic noteItem) => [
        if (noteItem.title.isNotEmpty) TitleModel(text: noteItem.title),
        if (noteItem.description.isNotEmpty)
          SubtitleModel(text: noteItem.description),
        for (final item in noteItem.content.items)
          item.text.isEmpty || item.text == ' '
              ? const DividerModel()
              : NoteListModel(text: item.text)
      ];
}
