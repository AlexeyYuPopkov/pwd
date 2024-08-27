import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';

import 'package:pwd/l10n/localization_helper.dart';
import 'package:pwd/notes/presentation/note_details/bloc/note_details_screen_bloc.dart';
import 'package:pwd/notes/presentation/tools/read_note_usecase_error_message_provider.dart';
import 'package:pwd/theme/common_size.dart';
import 'bloc/note_details_screen_state.dart';

final class NoteDetailsScreen extends StatelessWidget
    with ShowErrorDialogMixin {
  final String _configId;
  final String _noteId;

  const NoteDetailsScreen({
    super.key,
    required String configId,
    required String noteId,
  })  : _configId = configId,
        _noteId = noteId;

  void _listener(BuildContext context, NoteDetailsScreenState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    switch (state) {
      case CommonState():
      case LoadingState():
        break;
      case ErrorState():
        showError(
          context,
          state.e,
          errorMessageProviders: [
            const ReadNoteUsecaseErrorMessageProvider().call,
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.pageTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(CommonSize.indent2x),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: BlocProvider(
              create: (context) => NoteDetailsScreenBloc(
                configId: _configId,
                noteId: _noteId,
                readNoteUsecase: DiStorage.shared.resolve(),
              ),
              child:
                  BlocConsumer<NoteDetailsScreenBloc, NoteDetailsScreenState>(
                listener: _listener,
                builder: (context, state) {
                  const cacheExtent = 76.0;

                  return state.data.lines.isEmpty
                      ? const SizedBox()
                      : ListView.builder(
                          itemCount: state.data.lines.length,
                          cacheExtent: cacheExtent,
                          itemBuilder: (context, index) {
                            return state.data.lines[index].build(context);
                          },
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on BuildContext {
  String get pageTitle => localization.noteDetailsScreenTitle;
}
