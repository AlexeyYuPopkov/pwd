import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/presentation/validators/common/common_field_input_formatter.dart';

import 'package:pwd/common/presentation/validators/noEmpty/no_empty_validator.dart';
import 'package:pwd/common/presentation/validators/common/validator.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/file_name_validator.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/remote_settings_field_validator.dart';
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
  final remoteSettingsFieldValidator = const RemoteSettingsFieldValidator();
  final remoteSettingsFieldInputFormatter =
      const RemoteSettingsFieldInputFormatter();

  final fileNameValidator = const FileNameValidator();
  final fileNameInputFormatter = const FileNameInputFormatter();

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
              _TextFieldRow(
                hint: context.tokenTextFieldHint,
                tooltipMessage: context.tokenTooltip,
                controller: tokenController,
                validator: noEmptyValidator,
                inputFormatter: null,
              ),
              const SizedBox(height: CommonSize.indent2x),
              _TextFieldRow(
                hint: context.repoTextFieldHint,
                tooltipMessage: context.repoTooltip,
                controller: repoController,
                validator: remoteSettingsFieldValidator,
                inputFormatter: remoteSettingsFieldInputFormatter,
              ),
              const SizedBox(height: CommonSize.indent2x),
              _TextFieldRow(
                hint: context.ownerTextFieldHint,
                tooltipMessage: context.ownerTooltip,
                controller: ownerController,
                validator: remoteSettingsFieldValidator,
                inputFormatter: remoteSettingsFieldInputFormatter,
              ),
              const SizedBox(height: CommonSize.indent2x),
              _TextFieldRow(
                hint: context.branchTextFieldHint,
                tooltipMessage: context.branchTooltip,
                controller: branchController,
                validator: remoteSettingsFieldValidator,
                inputFormatter: remoteSettingsFieldInputFormatter,
              ),
              const SizedBox(height: CommonSize.indent2x),
              _TextFieldRow(
                hint: context.fileNameTextFieldHint,
                tooltipMessage: context.fileTooltip,
                controller: fileNameController,
                validator: fileNameValidator,
                inputFormatter: fileNameInputFormatter,
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

class _TextFieldRow extends StatelessWidget {
  final TextEditingController controller;
  final Validator validator;
  final CommonFieldInputFormatter? inputFormatter;
  final String hint;
  final String tooltipMessage;

  const _TextFieldRow({
    Key? key,
    required this.controller,
    required this.validator,
    required this.inputFormatter,
    required this.hint,
    required this.tooltipMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: hint,
            ),
            validator: (str) => validator(str)?.message(context),
            inputFormatters: inputFormatter?.call(),
          ),
        ),
        Tooltip(
          message: tooltipMessage,
          child: const Icon(
            Icons.help,
            size: CommonSize.smallIcon,
          ),
        ),
      ],
    );
  }
}

extension on BuildContext {
  String get description => 'Create a git repository to sync records. '
      'Create a file for store records. '
      'Then enter repository details';

  String get tokenTextFieldHint => 'Token';
  String get tokenTooltip => 'Go to your GitHub account '
      '(Settings -> Developer settings -> Tokens -> Generate new token) '
      'than create access token ang paste there';

  String get repoTextFieldHint => 'Repo';
  String get repoTooltip => 'Create GitHub repo than paste repo name';
  String get ownerTextFieldHint => 'Owner';
  String get ownerTooltip => 'Paste your GitHub user name';
  String get branchTextFieldHint => 'Branch';
  String get branchTooltip =>
      'Create branch in your `repo` than paste branch name';
  String get fileNameTextFieldHint => 'File name';
  String get fileTooltip => 'Create {your repo}/{your brunch}/{file_name} '
      'then paste {file_name}.';

  String get saveButtonTitle => 'Next';
}
