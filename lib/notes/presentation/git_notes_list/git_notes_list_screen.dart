import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

import 'package:pwd/common/presentation/app_bar_button.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/notes/domain/usecases/git_notes_provider_usecase.dart';
import 'package:pwd/notes/presentation/common/widgets/note_list_item_widget.dart';
import 'package:pwd/notes/presentation/git_notes_list/note_page_route.dart';

import 'package:pwd/notes/presentation/tools/crypt_error_message_provider.dart';
import 'package:pwd/notes/presentation/tools/notes_provider_error_message_provider.dart';
import 'package:pwd/notes/presentation/tools/sync_data_error_message_provider.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/git_notes_list_bloc.dart';
import 'git_notes_list_screen_test_helper.dart';

final class GitNotesListScreen extends StatelessWidget
    with ShowErrorDialogMixin {
  final GitConfiguration configuration;
  final Future Function(BuildContext, Object) onRoute;

  late final bloc = GitNotesListBloc(
    configuration: configuration,
    notesProviderUsecase: DiStorage.shared.resolve<GitNotesProviderUsecase>(),
    syncDataUsecase: DiStorage.shared.resolve(),
    shouldCreateRemoteStorageFileUsecase: DiStorage.shared.resolve(),
  );

  GitNotesListScreen({
    super.key,
    required this.configuration,
    required this.onRoute,
  });

  void _listener(BuildContext context, GitNotesListState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    if (state is ErrorState) {
      showError(
        context,
        state.error,
        errorMessageProviders: [
          const NotesProviderErrorMessageProvider().call,
          const SyncDataErrorMessageProvider().call,
          const CryptErrorMessageProvider().call,
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<GitNotesListBloc, GitNotesListState>(
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
                  key: const Key(GitNotesListScreenTestHelper.addNoteButtonKey),
                  iconData: Icons.add,
                  onPressed: () => _onEditButton(
                    context,
                    note: NoteItem.newItem(),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: BlocBuilder<GitNotesListBloc, GitNotesListState>(
                buildWhen: (old, current) =>
                    old.data.notes != current.data.notes,
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: () async => _onPullToRefresh(context),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.data.notes.length,
                      itemBuilder: (context, index) => NoteListItemWidget(
                        note: state.data.notes[index],
                        onDetailsButton: _onDetailsButton,
                        onEditButton: _onEditButton,
                      ),
                      separatorBuilder: (_, __) => const Divider(
                        height: CommonSize.thickness,
                      ),
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
      bloc.add(const GitNotesListEvent.sync());

  void _onPullToRefresh(BuildContext context) =>
      bloc.add(const GitNotesListEvent.refresh());

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
  }) {
    onRoute(
      context,
      NotePageRoute.onEdit(noteItem: note),
    ).then(
      (result) {
        if (result is NotePageShouldSync) {
          bloc.add(
            const GitNotesListEvent.shouldSync(),
          );
        }
      },
    );
  }
}

extension on BuildContext {
  String get pageTitle => 'Note';
}
