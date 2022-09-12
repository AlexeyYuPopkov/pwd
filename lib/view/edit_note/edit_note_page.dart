import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/common_sizes.dart';
import 'package:pwd/common/di/di_scope.dart';
import 'package:pwd/domain/gateway.dart';

import 'bloc/edit_note_bloc.dart';

class EditNotePage extends StatelessWidget {
  const EditNotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.pageTitle),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const IconButton(
              icon: Icon(Icons.add),
              onPressed: null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => EditNoteBloc(
            note: null,
            gateway: DiScope.single().resolve<Gateway>(),
          ),
          child: BlocConsumer<EditNoteBloc, EditNoteState>(
            listener: (context, state) {
              // TODO: implement listener
              // LoadingState
            },
            builder: (context, state) {
              final noteItem = state.data.noteItem;
              if (noteItem == null) {
                return const SizedBox();
              } else {
                return _Form();
              }
            },
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  late final formKey = GlobalKey<FormState>();
  late final titleController = TextEditingController();
  late final descriptionController = TextEditingController();
  late final contentController = TextEditingController();

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
      padding: const EdgeInsets.all(CommonSizes.doubleIndent),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: CommonSizes.doubleIndent),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: context.titleTextFieldTitle,
              ),
            ),
            const SizedBox(height: CommonSizes.doubleIndent),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: context.descriptionTextFieldTitle,
              ),
            ),
            const SizedBox(height: CommonSizes.doubleIndent),
            TextFormField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: context.contentTextFieldTitle,
              ),
            ),
            const SizedBox(height: CommonSizes.doubleIndent),
            CupertinoButton(
              onPressed: () => _onSave(context),
              child: Text(context.saveButtonTitle),
            ),
            const SizedBox(height: CommonSizes.doubleIndent),
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
