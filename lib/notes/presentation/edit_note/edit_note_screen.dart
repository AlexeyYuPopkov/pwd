import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/l10n/localization_helper.dart';
import 'package:rxdart/subjects.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/notes/presentation/tools/sync_data_error_message_provider.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/edit_note_bloc.dart';
import 'edit_note_screen_test_helper.dart';

part 'edit_note_page_results_part.dart';

final class EditNoteScreenInput {
  final BaseNoteItem noteItem;
  final RemoteConfiguration configuration;

  const EditNoteScreenInput({
    required this.noteItem,
    required this.configuration,
  });
}

final class EditNoteScreen extends StatelessWidget
    with ShowErrorDialogMixin, DialogHelper {
  final formKey = GlobalKey<_FormState>();

  final EditNoteScreenInput input;

  final Future Function(BuildContext, Object) onRoute;

  final isSubmitEnabledStream = BehaviorSubject.seeded(false);

  EditNoteScreen({
    super.key,
    required this.input,
    required this.onRoute,
  });

  void _listener(BuildContext context, EditNoteState state) async {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    switch (state) {
      case LoadingState():
      case CommonState():
        break;
      case DidSaveState():
        await onRoute(
          context,
          EditNotePagePopResult.didUpdate(
            noteItem: state.data.noteItem,
          ),
        );
      case DidDeleteState():
        await onRoute(
          context,
          const EditNotePagePopResult.didDidDelete(),
        );
        break;

      case ErrorState(e: final e):
        showError(
          context,
          e,
          errorMessageProviders: [
            const SyncDataErrorMessageProvider().call,
          ],
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.screenTitle),
        ),
        body: BlocProvider(
          create: (context) => EditNoteBloc(
            configuration: input.configuration,
            readNotesUsecase: DiStorage.shared.resolve(),
            updateNoteUsecase: DiStorage.shared.resolve(),
            deleteNoteUsecase: DiStorage.shared.resolve(),
            noteItem: input.noteItem,
          ),
          child: BlocConsumer<EditNoteBloc, EditNoteState>(
            key: const Key(_TestHelper.blocConsumerKey),
            listener: _listener,
            builder: (context, state) => CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _Form(
                    key: formKey,
                    noteItem: state.data.noteItem,
                    isSaveEnabledStream: isSubmitEnabledStream,
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: CommonSize.indent2x,
                        right: CommonSize.indent2x,
                        bottom: CommonSize.indent2x,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: StreamBuilder<bool>(
                                    initialData: false,
                                    stream: isSubmitEnabledStream,
                                    builder: (context, snapshot) {
                                      return OutlinedButton(
                                        key: const Key(
                                          _TestHelper.saveButtonKey,
                                        ),
                                        onPressed: snapshot.data ?? false
                                            ? () => _onSave(context)
                                            : null,
                                        child: Text(context.saveButtonTitle),
                                      );
                                    }),
                              ),
                              const SizedBox(width: CommonSize.indent2x),
                              Flexible(
                                fit: FlexFit.tight,
                                child: OutlinedButton(
                                  key: const Key(
                                    _TestHelper.deleteButtonKey,
                                  ),
                                  onPressed: input.noteItem is NewNoteItem
                                      ? null
                                      : () => _onDelete(context),
                                  child: Text(context.deleteButtonTitle),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSave(BuildContext context) {
    final formState = formKey.currentState;

    if (formState != null &&
        formState.formKey.currentState?.validate() == true) {
      final String content = formState.contentController.text;

      if (content.isNotEmpty) {
        formState.formKey.currentState?.save();
        context.read<EditNoteBloc>().add(
              EditNoteEvent.save(
                content: content,
              ),
            );
      }
    }
  }

  void _onDelete(BuildContext context) {
    showOkCancelDialog(
      context,
      title: context.deleteConfirmationMessage,
      onOk: (dialogContext) {
        Navigator.of(dialogContext).pop();
        context.read<EditNoteBloc>().add(
              const EditNoteEvent.delete(),
            );
      },
    );
  }
}

class _Form extends StatefulWidget {
  final BaseNoteItem noteItem;
  final BehaviorSubject isSaveEnabledStream;

  const _Form({
    super.key,
    required this.noteItem,
    required this.isSaveEnabledStream,
  });

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  late final formKey = GlobalKey<FormState>();

  late final contentController = TextEditingController(
    text: widget.noteItem.content.str,
  );

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(CommonSize.indent2x),
      child: Form(
        key: formKey,
        onChanged: _shouldChangeSubmitEnabledStatusIfNeeded,
        child: Column(
          children: [
            const SizedBox(height: CommonSize.indent2x),
            TextFormField(
              key: const Key(_TestHelper.contentTextFieldKey),
              controller: contentController,
              decoration: InputDecoration.collapsed(
                hintText: context.contentTextFieldTitle,
              ),
              minLines: calculatedMaxLines,
              maxLines: calculatedMaxLines + 10,
            ),
            const SizedBox(height: CommonSize.indent2x),
          ],
        ),
      ),
    );
  }

  void _shouldChangeSubmitEnabledStatusIfNeeded() {
    final checkResult = checkIsSubmitEnabled();

    if (checkResult != widget.isSaveEnabledStream.value) {
      widget.isSaveEnabledStream.add(checkResult);
    }
  }

  bool checkIsSubmitEnabled() =>
      widget.noteItem.content.str != contentController.text;

  int get calculatedMaxLines => contentController.text.split('\n').length;
}

// Localization
extension on BuildContext {
  String get screenTitle => localization.editNoteScreenScreenTitle;
  String get contentTextFieldTitle => localization.editNoteScreenContentField;
  String get saveButtonTitle => localization.commonSave;
  String get deleteButtonTitle => localization.commonDelete;
  String get deleteConfirmationMessage =>
      localization.editNoteScreenDeleteConfirmationMessage;
}
