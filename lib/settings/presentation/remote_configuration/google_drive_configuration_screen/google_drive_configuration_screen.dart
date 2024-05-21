import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/file_name_validator.dart';
import 'package:pwd/common/presentation/widgets/common_text_field_row.dart';
import 'package:pwd/settings/presentation/remote_configuration/error_message_providers/remote_configurations_error_message_provider.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc_data.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc_event.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc_state.dart';
import 'package:pwd/settings/presentation/remote_configuration/widgets/configuration_form_next_buttom_widget.dart';
import 'package:pwd/theme/common_size.dart';

import 'google_drive_configuration_screen_test_helper.dart';

typedef _TestHelper = GoogleDriveConfigurationScreenTestHelper;

final class GoogleDriveConfigurationScreen extends StatelessWidget
    with ShowErrorDialogMixin {
  final GoogleDriveConfiguration? initial;
  const GoogleDriveConfigurationScreen({super.key, required this.initial});

  void _listener(BuildContext context, SetConfigurationBlocState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    switch (state) {
      case LoadingState():
      case CommonState():
        break;
      case SavedState():
        Navigator.of(context).maybePop();
        break;
      case ErrorState(e: final e):
        showError(
          context,
          e,
          errorMessageProviders: [
            const RemoteConfigurationsErrorMessageProvider().call,
          ],
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.screenTitle),
      ),
      body: BlocProvider(
        create: (_) => SetConfigurationBloc(
          initialData: initial,
          addConfigurationsUsecase: DiStorage.shared.resolve(),
          removeConfigurationsUsecase: DiStorage.shared.resolve(),
        ),
        child: BlocConsumer<SetConfigurationBloc, SetConfigurationBlocState>(
          listener: _listener,
          builder: (_, state) => _Form(
            initial: initial,
            mode: state.data.mode,
          ),
        ),
      ),
    );
  }
}

// _Form
final class _Form extends StatefulWidget {
  final GoogleDriveConfiguration? initial;
  final SetConfigurationBlocMode mode;

  const _Form({
    required this.initial,
    required this.mode,
  });

  @override
  State<_Form> createState() => __FormState();
}

final class __FormState extends State<_Form> with DialogHelper {
  final fileNameValidator = const FileNameValidator();
  final fileNameInputFormatter = const FileNameInputFormatter();
  bool isValidForm = false;

  bool get isButtonEnabled {
    switch (widget.mode) {
      case SetConfigurationBlocMode.newConfiguration:
        return isValidForm;
      case SetConfigurationBlocMode.editConfiguration:
        return true;
    }
  }

  late final isTextFieldReadOnly =
      widget.mode == SetConfigurationBlocMode.editConfiguration;

  late final formKey = GlobalKey<FormState>();
  late final filenameController = TextEditingController(
    text: widget.initial?.fileName,
  );

  @override
  void dispose() {
    filenameController.dispose();
    super.dispose();
  }

  bool checkIfFormValid() => [
        fileNameValidator(filenameController.text),
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
                      key: const Key(_TestHelper.filenameTextFieldKey),
                      isReadOnly: isTextFieldReadOnly,
                      isEnabled: !isTextFieldReadOnly,
                      hint: context.fileNameTextFieldHint,
                      tooltipMessage: context.fileNameTooltip,
                      controller: filenameController,
                      validator: fileNameValidator,
                      inputFormatter: fileNameInputFormatter,
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

        context.read<SetConfigurationBloc>().add(
              SetConfigurationBlocEvent.newConfiguration(
                configuration: GoogleDriveConfiguration(
                  fileName: filenameController.text,
                ),
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

// Localization
extension on BuildContext {
  String get screenTitle => 'Setup synchronization';
  String get description =>
      'Fill form to setup synchronization via Google drive API';
  String get fileNameTextFieldHint => 'File Name';
  String get fileNameTooltip => 'Name of file for synchronization';

  String get confirmationMessageDeleteTitle => 'Warning';
  String get confirmationMessageDeleteMessage =>
      'Are you sure you want delete configuration from the device?';
}
