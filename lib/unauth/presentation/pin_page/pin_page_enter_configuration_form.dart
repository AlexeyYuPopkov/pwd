import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/presentation/validators/noEmpty/no_empty_validator.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/pin_page_bloc.dart';

class PinPageEnterConfigurationForm extends StatefulWidget {
  const PinPageEnterConfigurationForm({Key? key}) : super(key: key);

  @override
  State<PinPageEnterConfigurationForm> createState() =>
      _PinPageEnterConfigurationFormState();
}

class _PinPageEnterConfigurationFormState
    extends State<PinPageEnterConfigurationForm> {
  late final formKey = GlobalKey<FormState>();
  late final tokenController = TextEditingController();
  late final repoController = TextEditingController();
  late final ownerController = TextEditingController();
  late final branchController = TextEditingController();
  late final fileNameController = TextEditingController();

  final noEmptyValidator = const NoEmptyValidator();

  @override
  void dispose() {
    tokenController.dispose();
    repoController.dispose();
    ownerController.dispose();
    fileNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(CommonSize.indent2x),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: CommonSize.indent2x),
              Text(
                context.description,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CommonSize.indent2x),
              TextFormField(
                controller: tokenController,
                decoration: InputDecoration(
                  labelText: context.tokenTextFieldHint,
                ),
                validator: (str) => noEmptyValidator(str)?.message(context),
              ),
              const SizedBox(height: CommonSize.indent2x),
              TextFormField(
                controller: repoController,
                decoration: InputDecoration(
                  labelText: context.repoTextFieldHint,
                ),
                validator: (str) => noEmptyValidator(str)?.message(context),
              ),
              const SizedBox(height: CommonSize.indent2x),
              TextFormField(
                controller: ownerController,
                decoration: InputDecoration(
                  labelText: context.ownerTextFieldHint,
                ),
                validator: (str) => noEmptyValidator(str)?.message(context),
              ),
                         const SizedBox(height: CommonSize.indent2x),
              TextFormField(
                controller: branchController,
                decoration: InputDecoration(
                  labelText: context.branchTextFieldHint,
                ),
                validator: (str) => noEmptyValidator(str)?.message(context),
              ),
              const SizedBox(height: CommonSize.indent2x),
              TextFormField(
                controller: fileNameController,
                decoration: InputDecoration(
                  labelText: context.fileNameTextFieldHint,
                ),
                validator: (str) => noEmptyValidator(str)?.message(context),
              ),
              const SizedBox(height: CommonSize.indent2x),
              CupertinoButton(
                onPressed: () => _onNext(context),
                child: Text(context.saveButtonTitle),
              ),
              const SizedBox(height: CommonSize.indent2x),
            ],
          ),
        ),
      ),
    );
  }

  bool get isValidForm => [
        noEmptyValidator(tokenController.text),
        noEmptyValidator(repoController.text),
        noEmptyValidator(ownerController.text),
        noEmptyValidator(branchController.text),
        noEmptyValidator(fileNameController.text),
      ].where((e) => e != null).isEmpty;

  void _onNext(BuildContext context) {
    if (formKey.currentState?.validate() == true) {
      if (isValidForm) {
        formKey.currentState?.save();

        context.read<PinPageBloc>().add(
              PinPageBlocEvent.setRemoteStorageConfiguration(
                token: tokenController.text,
                repo: repoController.text,
                owner: ownerController.text,
                branch: branchController.text,
                fileName: fileNameController.text,
              ),
            );
      }
    }
  }
}

extension on BuildContext {
  String get description => 'Create a git repository to sync records. '
      'Create a file (without extension) for store records. '
      'Then enter repository details';

  String get tokenTextFieldHint => 'Token';
  String get repoTextFieldHint => 'Repo';
  String get ownerTextFieldHint => 'Owner';
   String get branchTextFieldHint => 'Branch';
  String get fileNameTextFieldHint => 'File name';

  String get saveButtonTitle => 'Next';
}
