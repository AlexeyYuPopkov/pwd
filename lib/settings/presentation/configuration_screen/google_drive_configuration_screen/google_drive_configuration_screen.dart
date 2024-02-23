import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/presentation/validators/noEmpty/no_empty_validator.dart';
import 'package:pwd/common/presentation/widgets/common_text_field_row.dart';
import 'package:pwd/theme/common_size.dart';

import 'google_drive_configuration_screen_test_helper.dart';

final class GoogleDriveConfigurationFormResult {
  final GoogleDriveConfiguration configuration;

  const GoogleDriveConfigurationFormResult({
    required this.configuration,
  });
}

final class GoogleDriveConfigurationScreen extends StatelessWidget {
  final GoogleDriveConfiguration? initial;
  const GoogleDriveConfigurationScreen({super.key, required this.initial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _Form(initial: initial),
    );
  }
}

final class _Form extends StatefulWidget {
  final GoogleDriveConfiguration? initial;
  const _Form({required this.initial});

  @override
  State<_Form> createState() => __FormState();
}

final class __FormState extends State<_Form> {
  final noEmptyValidator = const NoEmptyValidator();
  bool isValidForm = false;

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
        noEmptyValidator(filenameController.text),
      ].where((e) => e != null).isEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
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
                    key: const Key(
                      GoogleDriveConfigurationScreenTestHelper
                          .filenameTextFieldKey,
                    ),
                    hint: context.fileNameTextFieldHint,
                    tooltipMessage: context.fileNameTooltip,
                    controller: filenameController,
                    validator: noEmptyValidator,
                    inputFormatter: null,
                  ),
                  const SizedBox(height: CommonSize.indent2x),
                ],
              ),
            ),
          ),
        ),
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.only(bottom: CommonSize.indent2x),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: OutlinedButton(
                key: const Key(
                  GoogleDriveConfigurationScreenTestHelper.saveButton,
                ),
                onPressed: isValidForm ? () => _onSave(context) : null,
                child: Text(context.saveButtonTitle),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSave(BuildContext context) {
    if (formKey.currentState?.validate() == true) {
      if (isValidForm) {
        formKey.currentState?.save();

        final result = GoogleDriveConfigurationFormResult(
          configuration: GoogleDriveConfiguration(
            fileName: filenameController.text,
          ),
        );

        Navigator.of(context).pop(result);
      }
    }
  }
}

// Localization
extension on BuildContext {
  String get description => 'Google drive configuration';

  String get fileNameTextFieldHint => 'File Name';
  String get fileNameTooltip => 'Name of file for synchronization';

  String get saveButtonTitle => 'Save';
}
