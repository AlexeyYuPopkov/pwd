import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/edit_note_bloc.dart';

class EditNotePageRoutePopWithResult {
  final NoteItem noteItem;

  EditNotePageRoutePopWithResult({
    required this.noteItem,
  });
}

class EditNotePage extends StatelessWidget with ShowErrorDialogMixin {
  final NoteItem noteItem;

  final Future Function(BuildContext, Object) onRoute;

  const EditNotePage({
    Key? key,
    required this.noteItem,
    required this.onRoute,
  }) : super(key: key);

  void _listener(BuildContext context, EditNoteState state) async {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    if (state is DidSaveState) {
      await onRoute(
        context,
        EditNotePageRoutePopWithResult(
          noteItem: state.data.noteItem,
        ),
      );
    } else if (state is ErrorState) {
      showError(context, state.error);
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
        body: SafeArea(
          child: BlocProvider(
            create: (context) => EditNoteBloc(
              noteItem: noteItem,
            ),
            child: BlocConsumer<EditNoteBloc, EditNoteState>(
              listener: _listener,
              builder: (_, state) => Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: _Form(
                        noteItem: state.data.noteItem,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}

class _Form extends StatefulWidget {
  final NoteItem noteItem;

  const _Form({
    Key? key,
    required this.noteItem,
  }) : super(key: key);

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
    text: widget.noteItem.content,
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
        child: Column(
          children: [
            const SizedBox(height: CommonSize.indent2x),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: context.titleTextFieldTitle,
              ),
            ),
            const SizedBox(height: CommonSize.indent2x),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: context.descriptionTextFieldTitle,
              ),
            ),
            const SizedBox(height: CommonSize.indent2x),
            TextFormField(
              controller: contentController,
              decoration: InputDecoration.collapsed(
                hintText: context.contentTextFieldTitle,
              ),
              minLines: 10,
              maxLines: 100,
            ),
            const SizedBox(height: CommonSize.indent2x),
            CupertinoButton(
              onPressed: () => _onSave(context),
              child: Text(context.saveButtonTitle),
            ),
            const SizedBox(height: CommonSize.indent2x),
          ],
        ),
      ),
    );
  }

  void _onSave(BuildContext context) {
    if (formKey.currentState?.validate() == true) {
      final String title = titleController.text;
      final String description = descriptionController.text;
      final String content = contentController.text;

      if (title.isNotEmpty || description.isNotEmpty || content.isNotEmpty) {
        formKey.currentState?.save();
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
}

extension on BuildContext {
  String get pageTitle => 'Add/Edit note';

  String get titleTextFieldTitle => 'Title';
  String get descriptionTextFieldTitle => 'Description';
  String get contentTextFieldTitle => 'Content';

  String get saveButtonTitle => 'Save';
}
