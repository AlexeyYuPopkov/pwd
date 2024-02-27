import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/common/presentation/validators/noEmpty/no_empty_validator.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/file_name_validator.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/remote_settings_field_validator.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/remote_settings_field_validator_not_required.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/remote_settings_file_name_validator.dart';
import 'package:pwd/common/presentation/widgets/common_text_field_row.dart';
import 'package:pwd/theme/common_size.dart';

import 'git_configuration_screen_test_helper.dart';

final class GitConfigurationFormResult {
  final GitConfiguration configuration;
  final bool needsCreateNewFile;

  const GitConfigurationFormResult({
    required this.configuration,
    required this.needsCreateNewFile,
  });
}

typedef _TestHelper = GitConfigurationScreenTestHelper;

final class GitConfigurationForm extends StatefulWidget {
  final GitConfiguration? initial;
  const GitConfigurationForm({super.key, required this.initial});

  @override
  State<GitConfigurationForm> createState() => _GitConfigurationFormState();
}

final class _GitConfigurationFormState extends State<GitConfigurationForm>
    with DialogHelper {
  bool isValidForm = false;

  late final formKey = GlobalKey<FormState>();
  late final tokenController = TextEditingController(
    text: widget.initial?.token,
  );
  late final repoController = TextEditingController(
    text: widget.initial?.repo,
  );
  late final ownerController = TextEditingController(
    text: widget.initial?.owner,
  );
  late final branchController = TextEditingController(
    text: widget.initial?.branch,
  );
  late final fileNameController = TextEditingController(
    text: widget.initial?.fileName,
  );

  final noEmptyValidator = const NoEmptyValidator();
  final remoteSettingsFieldValidator = const RemoteSettingsFieldValidator();
  final remoteSettingsFieldValidatorNotRequired =
      const RemoteSettingsFieldValidatorNotRequired();
  final remoteSettingsFileNameValidator =
      const RemoteSettingsFileNameValidator();
  final remoteSettingsFieldInputFormatter =
      const RemoteSettingsFieldInputFormatter();
  final remoteSettingsFieldNotRequiredInputFormatter =
      const RemoteSettingsFieldNotRequiredInputFormatter();
  final remoteSettingsFileNameInputFormatter =
      const RemoteSettingsFileNameInputFormatter();

  final fileNameValidator = const FileNameValidator();
  final fileNameInputFormatter = const FileNameInputFormatter();

  bool checkBoxState = false;

  @override
  void dispose() {
    tokenController.dispose();
    repoController.dispose();
    ownerController.dispose();
    branchController.dispose();
    fileNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        // physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(CommonSize.indent2x),
            child: SizedBox(
              child: Form(
                key: formKey,
                onChanged: () {
                  final isValid = checkIfFormValid();
                  if (isValidForm != isValid) {
                    setState(() => isValidForm = isValid);
                  }
                },
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
                    CommonTextFieldRow(
                      key: const Key(_TestHelper.tokenTextField),
                      hint: context.tokenTextFieldHint,
                      tooltipMessage: context.tokenTooltip,
                      controller: tokenController,
                      validator: noEmptyValidator,
                      inputFormatter: null,
                    ),
                    const SizedBox(height: CommonSize.indent2x),
                    CommonTextFieldRow(
                      key: const Key(_TestHelper.repoTextField),
                      hint: context.repoTextFieldHint,
                      tooltipMessage: context.repoTooltip,
                      controller: repoController,
                      validator: remoteSettingsFieldValidator,
                      inputFormatter: remoteSettingsFieldInputFormatter,
                    ),
                    const SizedBox(height: CommonSize.indent2x),
                    CommonTextFieldRow(
                      key: const Key(_TestHelper.ownerTextField),
                      hint: context.ownerTextFieldHint,
                      tooltipMessage: context.ownerTooltip,
                      controller: ownerController,
                      validator: remoteSettingsFieldValidator,
                      inputFormatter: remoteSettingsFieldInputFormatter,
                    ),
                    const SizedBox(height: CommonSize.indent2x),
                    CommonTextFieldRow(
                      key: const Key(_TestHelper.branchTextField),
                      hint: context.branchTextFieldHint,
                      tooltipMessage: context.branchTooltip,
                      controller: branchController,
                      validator: remoteSettingsFieldValidatorNotRequired,
                      inputFormatter:
                          remoteSettingsFieldNotRequiredInputFormatter,
                    ),
                    const SizedBox(height: CommonSize.indent2x),
                    CommonTextFieldRow(
                      key: const Key(
                        _TestHelper.fileNameTextField,
                      ),
                      hint: context.fileNameTextFieldHint,
                      tooltipMessage: context.fileTooltip,
                      controller: fileNameController,
                      validator: fileNameValidator,
                      inputFormatter: remoteSettingsFileNameInputFormatter,
                    ),
                    const SizedBox(height: CommonSize.indent2x),
                    Row(
                      children: [
                        SizedBox(
                          width: CommonSize.iconSize,
                          height: CommonSize.iconSize,
                          child: Checkbox(
                            key: const Key(
                              _TestHelper.checkbox,
                            ),
                            value: checkBoxState,
                            onChanged: (value) => _onCheckbox(
                              context,
                              newValue: value,
                            ),
                          ),
                        ),
                        const SizedBox(width: CommonSize.indent2x),
                        Expanded(
                          child: Text(context.checkboxDescription),
                        ),
                      ],
                    ),
                    const SizedBox(height: CommonSize.indent2x),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(bottom: CommonSize.indent2x),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: OutlinedButton(
                  key: const Key(_TestHelper.nextButton),
                  onPressed: isValidForm ? () => _onSave(context) : null,
                  child: Text(context.saveButtonTitle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool checkIfFormValid() => [
        noEmptyValidator(tokenController.text),
        remoteSettingsFieldValidator(repoController.text),
        remoteSettingsFieldValidator(ownerController.text),
        remoteSettingsFieldValidatorNotRequired(branchController.text),
        remoteSettingsFileNameValidator(fileNameController.text),
      ].where((e) => e != null).isEmpty;

  void _onCheckbox(
    BuildContext context, {
    required bool? newValue,
  }) {
    if (newValue == true) {
      showOkCancelDialog(
        context,
        title: context.createNewFileDialogPrompt,
        onOk: (dialogContext) {
          if (checkBoxState != newValue) {
            setState(() => checkBoxState = newValue ?? false);
          }

          Navigator.of(dialogContext).pop();
        },
      );
    } else {
      if (checkBoxState != newValue) {
        setState(() => checkBoxState = false);
      }
    }
  }

  void _onSave(BuildContext context) {
    if (formKey.currentState?.validate() == true) {
      if (isValidForm) {
        formKey.currentState?.save();

        final result = GitConfigurationFormResult(
          configuration: GitConfiguration(
            token: tokenController.text,
            repo: repoController.text,
            owner: ownerController.text,
            branch: branchController.text,
            fileName: fileNameController.text,
          ),
          needsCreateNewFile: checkBoxState,
        );

        Navigator.of(context).pop(result);
      }
    }
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

  String get checkboxDescription =>
      'Create new file. Overrides the old one, if present';

  String get createNewFileDialogPrompt =>
      'Do you shure whant override old file, if presents?';

  String get saveButtonTitle => 'Save';
}
