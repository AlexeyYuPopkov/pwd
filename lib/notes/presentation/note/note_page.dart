import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pwd/common/presentation/app_bar_button.dart';
import 'package:pwd/common/presentation/common_highlighted_row.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/presentation/note/note_page_route.dart';
import 'package:pwd/notes/presentation/tools/crypt_error_message_provider.dart';
import 'package:pwd/notes/presentation/tools/notes_provider_error_message_provider.dart';
import 'package:pwd/notes/presentation/tools/sync_data_error_message_provider.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/note_page_bloc.dart';

class NotePage extends StatelessWidget with ShowErrorDialogMixin {
  final Future Function(BuildContext, Object) onRoute;

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
          const CryptErrorMessageProvider(),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotePageBloc(
        notesProviderUsecase: DiStorage.shared.resolve<NotesProviderUsecase>(),
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
                    note: NoteItem.newItem(),
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
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) => _NoteListItemWidget(
                        note: state.data.notes[index],
                        onDetailsButton: _onDetailsButton,
                        onEditButton: _onEditButton,
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

  void _onDetailsButton(
    BuildContext context, {
    required NoteItem note,
  }) =>
      onRoute(
        context,
        NotePageRoute.onDetails(noteItem: note),
      );

  void _onEditButton(
    BuildContext context, {
    required NoteItem note,
  }) =>
      onRoute(
        context,
        NotePageRoute.onEdit(noteItem: note),
      ).then(
        (result) {
          if (result is NotePageShouldSync) {
            context.read<NotePageBloc>().add(
                  const NotePageEvent.shouldSync(),
                );
          }
        },
      );
}

class _NoteListItemWidget extends StatelessWidget {
  final NoteItem note;

  final void Function(
    BuildContext context, {
    required NoteItem note,
  }) onDetailsButton;

  final void Function(
    BuildContext context, {
    required NoteItem note,
  }) onEditButton;

  const _NoteListItemWidget({
    required this.note,
    required this.onDetailsButton,
    required this.onEditButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CommonHighlightedBackgroundRow(
      highlightedColor: Colors.grey.shade200,
      onTap: () => onDetailsButton(
        context,
        note: note,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CommonSize.indent2x,
          vertical: CommonSize.indent,
        ),
        child: Row(
          children: [
            Expanded(
              child: IgnorePointer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (note.title.isNotEmpty)
                      Text(
                        note.title,
                        style: theme.textTheme.titleMedium,
                      ),
                    if (note.description.isNotEmpty)
                      Text(
                        note.description,
                        style: theme.textTheme.titleSmall,
                      ),
                  ],
                ),
              ),
            ),
            if (note is! DecryptedNoteItem)
              Tooltip(
                message: context.rawNoteTooltipMessage,
                child: const Icon(
                  Icons.warning,
                  size: CommonSize.indent2x,
                ),
              ),
            CupertinoButton(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(left: CommonSize.indent2x),
              onPressed: () => onEditButton(
                context,
                note: note,
              ),
              child: const Icon(
                Icons.edit,
                size: CommonSize.indent2x,
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension on BuildContext {
  String get pageTitle => 'Note';
  String get rawNoteTooltipMessage => 'Not Encrypted';
}
