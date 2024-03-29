import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';

import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/notes/presentation/tools/sync_data_error_message_provider.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/edit_note_bloc.dart';
import 'edit_note_screen_test_helper.dart';

part 'edit_note_page_results_part.dart';

final class EditNoteScreen extends StatelessWidget
    with ShowErrorDialogMixin, DialogHelper {
  final formKey = GlobalKey<_FormState>();

  final BaseNoteItem noteItem;
  final RemoteConfiguration configuration;

  final Future Function(BuildContext, Object) onRoute;

  final isSubmitEnabledStream = BehaviorSubject.seeded(false);

  EditNoteScreen({
    super.key,
    required this.noteItem,
    required this.configuration,
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
          title: Text(context.pageTitle),
        ),
        body: BlocProvider(
          create: (context) => EditNoteBloc(
            configuration: configuration,
            notesProviderUsecase:
                DiStorage.shared.resolve<NotesProviderUsecase>(),
            deleteNoteUsecase: DiStorage.shared.resolve(),
            noteItem: noteItem,
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
                                  onPressed: noteItem is UpdatedNoteItem
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
      final String title = formState.titleController.text;
      final String description = formState.descriptionController.text;
      final String content = formState.contentController.text;

      if (title.isNotEmpty || description.isNotEmpty || content.isNotEmpty) {
        formState.formKey.currentState?.save();
        context.read<EditNoteBloc>().add(
              EditNoteEvent.save(
                title: title,
                description: description,
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
  late final titleController = TextEditingController(
    text: widget.noteItem.title,
  );
  late final descriptionController = TextEditingController(
    text: widget.noteItem.description,
  );
  late final contentController = TextEditingController(
    text: widget.noteItem.content.str,
  );

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
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
              key: const Key(_TestHelper.titleTextFieldKey),
              controller: titleController,
              decoration: InputDecoration(
                labelText: context.titleTextFieldTitle,
              ),
            ),
            const SizedBox(height: CommonSize.indent2x),
            TextFormField(
              key: const Key(_TestHelper.subtitleTextFieldKey),
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: context.descriptionTextFieldTitle,
              ),
            ),
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
      widget.noteItem.title != titleController.text ||
      widget.noteItem.description != descriptionController.text ||
      widget.noteItem.content.str != contentController.text;

  int get calculatedMaxLines => contentController.text.split('\n').length;
}

// Localization
extension on BuildContext {
  String get pageTitle => 'Add/Edit note';

  String get titleTextFieldTitle => 'Title';
  String get descriptionTextFieldTitle => 'Description';
  String get contentTextFieldTitle => 'Content';

  String get saveButtonTitle => 'Save';
  String get deleteButtonTitle => 'Delete';

  String get deleteConfirmationMessage =>
      'Do you really whant to delete the entry?';
}
