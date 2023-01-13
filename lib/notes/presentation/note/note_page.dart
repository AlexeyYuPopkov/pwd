import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pwd/common/common_sizes.dart';
import 'package:pwd/common/presentation/app_bar_button.dart';
import 'package:pwd/common/presentation/common_highlighted_row.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/notes/domain/notes_provider_repository.dart';
import 'package:pwd/notes/presentation/router/main_route_data.dart';
import 'package:pwd/notes/presentation/tools/notes_provider_error_message_provider.dart';
import 'package:pwd/notes/presentation/tools/sync_data_error_message_provider.dart';

import 'bloc/note_page_bloc.dart';

class NotePage extends StatelessWidget with ShowErrorDialogMixin {
  final Future Function(BuildContext, MainRouteData) onRoute;

  const NotePage({
    Key? key,
    required this.onRoute,
  }) : super(key: key);

  void _listener(BuildContext context, NotePageState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    if (state is ErrorState) {
      showError(
        context,
        state.error,
        errorMessageProviders: [
          const NotesProviderErrorMessageProvider(),
          const SyncDataErrorMessageProvider(),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotePageBloc(
        notesProviderUsecase:
            DiStorage.shared.resolve<NotesProviderRepository>(),
        syncDataUsecase: DiStorage.shared.resolve(),
      ),
      child: BlocConsumer<NotePageBloc, NotePageState>(
        listener: _listener,
        buildWhen: (old, current) => old.needsSync != current.needsSync,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.pageTitle),
              actions: [
                AppBarButton(
                  iconData: Icons.sync,
                  onPressed: state.needsSync ? () => _onSync(context) : null,
                ),
                AppBarButton(
                  iconData: Icons.add,
                  onPressed: () => _onEditButton(
                    context,
                    noteItem: NoteItem.newItem(),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: BlocBuilder<NotePageBloc, NotePageState>(
                buildWhen: (old, current) =>
                    old.data.notes != current.data.notes,
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: () async => _onPullToRefresh(context),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = state.data.notes[index];
                        return CommonHighlightedRow(
                          highlightedColor: Colors.grey.shade200,
                          onTap: () => _onEditButton(
                            context,
                            noteItem: item,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: CommonSizes.doubleIndent,
                              vertical: CommonSizes.doubleIndent,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Text(
                                  item.description,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: CommonSizes.indent,
                      ),
                      itemCount: state.data.notes.length,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _onSync(BuildContext context) =>
      context.read<NotePageBloc>().add(const NotePageEvent.sync());

  void _onPullToRefresh(BuildContext context) =>
      context.read<NotePageBloc>().add(const NotePageEvent.refresh());

  void _onEditButton(BuildContext context, {required NoteItem noteItem}) =>
      onRoute(
        context,
        MainRouteData.onEdit(noteItem: noteItem),
      ).then(
        (result) {
          if (result is NoteItem) {
            context.read<NotePageBloc>().add(
                  NotePageEvent.shouldUpdateNote(
                    noteItem: result,
                  ),
                );
          }
        },
      );
}

extension on BuildContext {
  String get pageTitle => 'Note';
}
