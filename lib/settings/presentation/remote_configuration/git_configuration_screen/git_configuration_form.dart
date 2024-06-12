part of 'git_configuration_screen.dart';

typedef _TestHelper = GitConfigurationScreenTestHelper;

final class GitConfigurationFormResult {
  final GitConfiguration configuration;

  const GitConfigurationFormResult({
    required this.configuration,
  });
}

final class GitConfigurationForm extends StatefulWidget {
  final GitConfiguration? initial;
  final SetConfigurationBlocMode mode;

  const GitConfigurationForm({
    super.key,
    required this.initial,
    required this.mode,
  });

  @override
  State<GitConfigurationForm> createState() => _GitConfigurationFormState();
}

final class _GitConfigurationFormState extends State<GitConfigurationForm>
    with DialogHelper {
  bool isValidForm = false;

  bool get isButtonEnabled {
    switch (widget.mode) {
      case SetConfigurationBlocMode.newConfiguration:
        return isValidForm;
      case SetConfigurationBlocMode.editConfiguration:
        return true;
    }
  }

  late final isTextFieldsReadOnly =
      widget.mode == SetConfigurationBlocMode.editConfiguration;

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

  @override
  void dispose() {
    tokenController.dispose();
    repoController.dispose();
    ownerController.dispose();
    branchController.dispose();
    fileNameController.dispose();

    super.dispose();
  }

  bool checkIfFormValid() => [
        noEmptyValidator(tokenController.text),
        remoteSettingsFieldValidator(repoController.text),
        remoteSettingsFieldValidator(ownerController.text),
        remoteSettingsFieldValidatorNotRequired(branchController.text),
        remoteSettingsFileNameValidator(fileNameController.text),
      ].where((e) => e != null).isEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        formKey.currentState?.validate();
        FocusScope.of(context).unfocus();
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(CommonSize.indent2x),
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
                      isReadOnly: isTextFieldsReadOnly,
                      isEnabled: !isTextFieldsReadOnly,
                      hint: context.tokenTextFieldHint,
                      tooltipMessage: context.tokenTooltip,
                      controller: tokenController,
                      validator: noEmptyValidator,
                      inputFormatter: null,
                    ),
                    const SizedBox(height: CommonSize.indent2x),
                    CommonTextFieldRow(
                      key: const Key(_TestHelper.repoTextField),
                      isReadOnly: isTextFieldsReadOnly,
                      isEnabled: !isTextFieldsReadOnly,
                      hint: context.repoTextFieldHint,
                      tooltipMessage: context.repoTooltip,
                      controller: repoController,
                      validator: remoteSettingsFieldValidator,
                      inputFormatter: remoteSettingsFieldInputFormatter,
                    ),
                    const SizedBox(height: CommonSize.indent2x),
                    CommonTextFieldRow(
                      key: const Key(_TestHelper.ownerTextField),
                      isReadOnly: isTextFieldsReadOnly,
                      isEnabled: !isTextFieldsReadOnly,
                      hint: context.ownerTextFieldHint,
                      tooltipMessage: context.ownerTooltip,
                      controller: ownerController,
                      validator: remoteSettingsFieldValidator,
                      inputFormatter: remoteSettingsFieldInputFormatter,
                    ),
                    const SizedBox(height: CommonSize.indent2x),
                    CommonTextFieldRow(
                      key: const Key(_TestHelper.branchTextField),
                      isReadOnly: isTextFieldsReadOnly,
                      isEnabled: !isTextFieldsReadOnly,
                      hint: context.branchTextFieldHint,
                      tooltipMessage: context.branchTooltip,
                      controller: branchController,
                      validator: remoteSettingsFieldValidatorNotRequired,
                      inputFormatter:
                          remoteSettingsFieldNotRequiredInputFormatter,
                    ),
                    const SizedBox(height: CommonSize.indent2x),
                    CommonTextFieldRow(
                      key: const Key(_TestHelper.fileNameTextField),
                      isReadOnly: isTextFieldsReadOnly,
                      isEnabled: !isTextFieldsReadOnly,
                      hint: context.fileNameTextFieldHint,
                      tooltipMessage: context.fileTooltip,
                      controller: fileNameController,
                      validator: fileNameValidator,
                      inputFormatter: remoteSettingsFileNameInputFormatter,
                    ),
                    const SizedBox(height: CommonSize.indent2x),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: ConfigurationFormNextButtomWidget(
              mode: widget.mode,
              onTap: isButtonEnabled ? () => _onNext(context) : null,
            ),
          ),
        ],
      ),
    );
  }

  void _onNext(BuildContext context) {
    switch (widget.mode) {
      case SetConfigurationBlocMode.newConfiguration:
        _onNew(context);
        return;
      case SetConfigurationBlocMode.editConfiguration:
        _onDelete(context);
        return;
    }
  }

  void _onNew(BuildContext context) {
    if (formKey.currentState?.validate() == true) {
      if (isValidForm) {
        formKey.currentState?.save();

        final result = GitConfiguration(
          token: tokenController.text,
          repo: repoController.text,
          owner: ownerController.text,
          branch: branchController.text,
          fileName: fileNameController.text,
        );

        context.read<SetConfigurationBloc>().add(
              SetConfigurationBlocEvent.newConfiguration(
                configuration: result,
              ),
            );
      }
    }
  }

  void _onDelete(BuildContext context) => showOkCancelDialog(
        context,
        title: context.confirmationMessageDeleteTitle,
        message: context.confirmationMessageDeleteMessage,
        onOk: (dialogContext) {
          context.read<SetConfigurationBloc>().add(
                const SetConfigurationBlocEvent.deleteConfiguration(),
              );
          Navigator.of(dialogContext).maybePop();
        },
      );
}

extension on BuildContext {
  Localization get localization => Localization.of(this)!;
  String get description => localization.gitConfigurationFormFormDescription;
  String get tokenTextFieldHint =>
      localization.gitConfigurationFormTokenTextField;
  String get tokenTooltip => localization.gitConfigurationFormTokenTooltip;
  String get repoTextFieldHint =>
      localization.gitConfigurationFormRepoTextFieldHint;
  String get repoTooltip => localization.gitConfigurationFormRepoTooltip;
  String get ownerTextFieldHint =>
      localization.gitConfigurationFormOwnerTextFieldHint;
  String get ownerTooltip => localization.gitConfigurationFormOwnerTooltip;
  String get branchTextFieldHint =>
      localization.gitConfigurationFormBranchTextFieldHint;
  String get branchTooltip => localization.gitConfigurationFormBranchTooltip;
  String get fileNameTextFieldHint =>
      localization.gitConfigurationFormFileNameTextFieldHint;
  String get fileTooltip => localization.gitConfigurationFormFileTooltip;
  String get confirmationMessageDeleteTitle =>
      localization.gitConfigurationFormConfirmationMessageDeleteTitle;
  String get confirmationMessageDeleteMessage =>
      localization.gitConfigurationFormConfirmationMessageDeleteMessage;
}
