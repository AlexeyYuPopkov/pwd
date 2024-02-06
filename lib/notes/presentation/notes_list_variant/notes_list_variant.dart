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
import 'package:pwd/notes/presentation/tools/debug_error_message_provider.dart';
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
        googleSyncUsecase: DiStorage.shared.resolve(),
      ),
      child: BlocConsumer<NotesListVariantBloc, NotesListVariantBlocState>(
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
                  key: const Key('test_add_note_button'),
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
                    onEdit: _onEdit,
                    onDetails: _onDetails,
                  ),
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
            const DebugErrorMessageProvider().call,
            // const NotesProviderErrorMessageProvider().call,
            // const SyncDataErrorMessageProvider().call,
            // const CryptErrorMessageProvider().call,
          ],
        );
    }
  }

  void _onSync(BuildContext context) => context
      .read<NotesListVariantBloc>()
      .add(const NotesListVariantBlocEvent.sync());

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
          context.read<NotesListVariantBloc>().add(
                const NotesListVariantBlocEvent.sync(),
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
  final void Function(BuildContext, {required NoteItem note}) onEdit;
  final void Function(BuildContext, {required NoteItem note}) onDetails;

  const _NotesList({
    required this.notes,
    required this.onEdit,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
