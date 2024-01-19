import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/usecases/google_sync_usecase.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase_variant.dart';

import 'notes_list_variant_bloc_data.dart';
import 'notes_list_variant_bloc_event.dart';
import 'notes_list_variant_bloc_state.dart';

class NotesListVariantBloc
    extends Bloc<NotesListVariantBlocEvent, NotesListVariantBlocState> {
  NotesListVariantBlocData get data => state.data;

  final NotesProviderUsecaseVariant notesProviderUsecase;
  // final SyncDataVariantUsecase syncNotesVariantUsecase;
  // final HashUsecase hashUsecase;

  final GoogleSyncUsecase googleSyncUsecase;

  // final sqlToRealmUsecase = SqlToRealmUsecase(
  //   notesProviderUsecase: DiStorage.shared.resolve(),
  //   notesProviderUsecaseVariant: DiStorage.shared.resolve(),
  //   repository: DiStorage.shared.resolve(),
  //   pinUsecase: DiStorage.shared.resolve(),
  // );

  Stream<List<NoteItem>> get noteStream => notesProviderUsecase.noteStream;

  StreamSubscription? subscription;

  NotesListVariantBloc({
    required this.notesProviderUsecase,
    // required this.syncNotesVariantUsecase,
    // required this.hashUsecase,
    required this.googleSyncUsecase,
  }) : super(
          InitialState(
            data: NotesListVariantBlocData.initial(),
          ),
        ) {
    _setupHandlers();

    subscription = noteStream.listen(
      (notes) {
        add(NotesListVariantBlocEvent.newNotes(notes: notes));
      },
      onError: (e) => add(NotesListVariantBlocEvent.error(e: e)),
      cancelOnError: false,
    );

    // add(const GetFileListEvent());

    notesProviderUsecase.readNotes();
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }

  void _setupHandlers() {
    on<NewNotesEvent>(_onNewNotesEvent);
    on<SyncEvent>(_onSyncEvent);
    // on<SqlToRealmEvent>(_onSqlToRealmEvent);
  }

  void _onNewNotesEvent(
    NewNotesEvent event,
    Emitter<NotesListVariantBlocState> emit,
  ) {
    emit(
      NotesListVariantBlocState.common(
        data: data.copyWith(notes: event.notes),
      ),
    );
  }

  void _onSyncEvent(
    SyncEvent event,
    Emitter<NotesListVariantBlocState> emit,
  ) async {
    try {
      emit(NotesListVariantBlocState.loading(data: data));

      // await syncNotesVariantUsecase.sync();

      await googleSyncUsecase.sync();

      emit(NotesListVariantBlocState.common(data: data));
    } catch (e) {
      emit(NotesListVariantBlocState.error(data: data, e: e));
    }
  }

  // void _onSqlToRealmEvent(
  //   SqlToRealmEvent event,
  //   Emitter<NotesListVariantBlocState> emit,
  // ) async {
  //   try {
  //     emit(NotesListVariantBlocState.loading(data: data));

  //     await sqlToRealmUsecase();

  //     emit(NotesListVariantBlocState.common(data: data));
  //   } catch (e) {
  //     emit(NotesListVariantBlocState.error(data: data, e: e));
  //   }
  // }

  // void _onGetFileListEvent(
  //   GetFileListEvent event,
  //   Emitter<NotesListVariantBlocState> emit,
  // ) async {
  //   try {
  //     emit(NotesListVariantBlocState.loading(data: data));

  //     final list = await getGoogleFileListUsecase.execute();

  //     emit(FilesListState(data: data, files: list));
  //   } catch (e) {
  //     emit(NotesListVariantBlocState.error(data: data, e: e));
  //   }
  // }
}
