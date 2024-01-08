import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/presentation/app_bar_button.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/presentation/shimmer/common_shimmer.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/presentation/common/widgets/note_list_item_widget.dart';
import 'package:pwd/notes/presentation/note/note_page_route.dart';
import 'package:pwd/notes/presentation/tools/crypt_error_message_provider.dart';
import 'package:pwd/notes/presentation/tools/notes_provider_error_message_provider.dart';
import 'package:pwd/notes/presentation/tools/sync_data_error_message_provider.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/notes_list_variant_bloc.dart';
import 'bloc/notes_list_variant_bloc_event.dart';
import 'bloc/notes_list_variant_bloc_state.dart';

final class NotesListVariant extends StatelessWidget with ShowErrorDialogMixin {
  final Future Function(BuildContext, Object) onRoute;

  const NotesListVariant({
    super.key,
    required this.onRoute,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesListVariantBloc(
        notesProviderUsecase: DiStorage.shared.resolve(),
        syncNotesVariantUsecase: DiStorage.shared.resolve(),
        hashUsecase: DiStorage.shared.resolve(),
      ),
      child: BlocConsumer<NotesListVariantBloc, NotesListVariantBlocState>(
        listener: _listener,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.pageTitle),
              actions: [
                AppBarButton(
                  iconData: Icons.get_app_outlined,
                  onPressed: () => _onSqlToRealm(context),
                ),
                AppBarButton(
                  iconData: Icons.sync,
                  onPressed: () => _onSync(context),
                ),
                AppBarButton(
                  key: const Key('test_add_note_button'),
                  iconData: Icons.add,
                  onPressed: () => _onEditButton(
                    context,
                    note: NoteItem.newItem(),
                  ),
                ),
              ],
            ),
            body: state is InitialState
                ? const _LoadingShimmer()
                : _Notes(notes: state.data.notes),
          );
        },
      ),
    );
  }

  void _listener(BuildContext context, NotesListVariantBlocState state) {
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
            const NotesProviderErrorMessageProvider().call,
            const SyncDataErrorMessageProvider().call,
            const CryptErrorMessageProvider().call,
          ],
        );
    }
  }

  void _onSync(BuildContext context) => context
      .read<NotesListVariantBloc>()
      .add(const NotesListVariantBlocEvent.sync());

  void _onSqlToRealm(BuildContext context) => context
      .read<NotesListVariantBloc>()
      .add(const NotesListVariantBlocEvent.sqlToRealm());

  void _onEditButton(
    BuildContext context, {
    required NoteItem note,
  }) {
    onRoute(
      context,
      NotePageRoute.onEdit(noteItem: note),
    ).then(
      (result) {
        // if (result is NotePageShouldSync) {
        //   bloc.add(
        //     const NotePageEvent.shouldSync(),
        //   );
        // }
      },
    );
  }
}

final class _Notes extends StatelessWidget {
  final List<NoteItem> notes;

  const _Notes({required this.notes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return NoteListItemWidget(
          note: notes[index],
          onDetailsButton: _onDetailsButton,
          onEditButton: _onEditButton,
        );
      },
    );
  }

  void _onDetailsButton(
    BuildContext context, {
    required NoteItem note,
  }) {}

  void _onEditButton(
    BuildContext context, {
    required NoteItem note,
  }) {}
}

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

extension on BuildContext {
  String get pageTitle => 'Note';
}
