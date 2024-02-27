import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/presentation/app_bar_button.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/presentation/shimmer/common_shimmer.dart';
import 'package:di_storage/di_storage.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/usecases/google_drive_notes_provider_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_git_item_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_google_drive_item_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';
import 'package:pwd/notes/presentation/common/widgets/note_list_item_widget.dart';
import 'package:pwd/notes/presentation/git_notes_list/note_page_route.dart';

import 'package:pwd/notes/presentation/tools/crypt_error_message_provider.dart';
import 'package:pwd/notes/presentation/tools/local_storage_error_message_provider.dart';
import 'package:pwd/notes/presentation/tools/notes_provider_error_message_provider.dart';
import 'package:pwd/notes/presentation/tools/sync_data_error_message_provider.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/google_drive_notes_list_bloc.dart';
import 'bloc/google_drive_notes_list_event.dart';
import 'bloc/google_drive_notes_list_state.dart';
import 'google_drive_notes_list_screen_test_helper.dart';

final class GoogleDriveNotesListScreen extends StatelessWidget
    with ShowErrorDialogMixin {
  final RemoteConfiguration configuration;
  final Future Function(BuildContext, Object) onRoute;

  const GoogleDriveNotesListScreen({
    super.key,
    required this.configuration,
    required this.onRoute,
  });

  SyncUsecase get syncUsecase {
    switch (configuration) {
      case GoogleDriveConfiguration():
        return DiStorage.shared.resolve<SyncGoogleDriveItemUsecase>();
      case GitConfiguration():
        return DiStorage.shared.resolve<SyncGitItemUsecase>();
    }
  }

  @override
  Widget build(BuildContext context) {
    final di = DiStorage.shared;
    return BlocProvider(
      create: (_) => GoogleDriveNotesListBloc(
        configuration: configuration,
        notesProviderUsecase: di.resolve<GoogleDriveNotesProviderUsecase>(),
        syncUsecase: syncUsecase,
      ),
      child: BlocConsumer<GoogleDriveNotesListBloc, GoogleDriveNotesListState>(
        listener: _listener,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.pageTitle),
              actions: [
                AppBarButton(
                  iconData: Icons.sync,
                  onPressed: () => _onSync(context),
                ),
                AppBarButton(
                  key: const Key(
                    GoogleDriveNotesListScreenTestHelper.addNoteButtonKey,
                  ),
                  iconData: Icons.add,
                  onPressed: () => _onEdit(
                    context,
                    note: NoteItem.newItem(),
                  ),
                ),
              ],
            ),
            body: state is InitialState
                ? const _LoadingShimmer()
                : _NotesList(
                    notes: state.data.notes,
                    onRefresh: _onPullToRefresh,
                    onEdit: _onEdit,
                    onDetails: _onDetails,
                  ),
          );
        },
      ),
    );
  }

  void _listener(BuildContext context, GoogleDriveNotesListState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    switch (state) {
      case InitialState():
      case CommonState():
      case LoadingState():
        break;
      case FilesListState():
        // print('Files:');
        // print(state.files.map((e) => '${e.name}\n'));
        break;
      case ErrorState(e: final e):
        showError(
          context,
          e,
          errorMessageProviders: [
            const LocalStorageErrorMessageProvider().call,
            const NotesProviderErrorMessageProvider().call,
            const SyncDataErrorMessageProvider().call,
            const CryptErrorMessageProvider().call,
          ],
        );
    }
  }

  void _onSync(BuildContext context) => context
      .read<GoogleDriveNotesListBloc>()
      .add(const GoogleDriveNotesListEvent.sync());

  Future<void> _onPullToRefresh(BuildContext context) async => _onSync(context);

  void _onEdit(
    BuildContext context, {
    required NoteItem note,
  }) {
    onRoute(
      context,
      NotePageRoute.onEdit(noteItem: note),
    ).then(
      (result) {
        if (result is NotePageShouldSync) {
          context.read<GoogleDriveNotesListBloc>().add(
                const GoogleDriveNotesListEvent.sync(),
              );
        }
      },
    );
  }

  void _onDetails(
    BuildContext context, {
    required NoteItem note,
  }) =>
      onRoute(
        context,
        NotePageRoute.onDetails(noteItem: note),
      );
}

// Notes List

final class _NotesList extends StatelessWidget {
  final List<NoteItem> notes;
  final Future Function(BuildContext) onRefresh;
  final void Function(BuildContext, {required NoteItem note}) onEdit;
  final void Function(BuildContext, {required NoteItem note}) onDetails;

  const _NotesList({
    required this.notes,
    required this.onRefresh,
    required this.onEdit,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => onRefresh(context),
      child: ListView.separated(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return NoteListItemWidget(
            note: notes[index],
            onDetailsButton: onDetails,
            onEditButton: onEdit,
          );
        },
        separatorBuilder: (_, __) => const Divider(
          height: CommonSize.thickness,
        ),
      ),
    );
  }
}

// _LoadingShimmer

final class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    const itemsCount = 10;

    return ListView.builder(
      itemCount: itemsCount,
      itemBuilder: (context, _) {
        return const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: CommonSize.indent2x,
            vertical: CommonSize.indentVariant,
          ),
          child: CommonShimmer(
            child: SizedBox(height: CommonSize.rowHeight),
          ),
        );
      },
    );
  }
}

// Private
extension on BuildContext {
  String get pageTitle => 'Note';
}
