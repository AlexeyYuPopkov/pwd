import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/presentation/validators/noEmpty/no_empty_validator.dart';
import 'package:pwd/common/presentation/widgets/common_text_field_row.dart';
import 'package:pwd/theme/common_size.dart';

final class GoogleDriveConfigurationFormResult {
  final GoogleDriveConfiguration configuration;

  const GoogleDriveConfigurationFormResult({
    required this.configuration,
  });
}

final class GoogleDriveConfigurationScreen extends StatelessWidget {
  const GoogleDriveConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const _Form(),
    );
  }
}

final class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

final class __FormState extends State<_Form> {
  final noEmptyValidator = const NoEmptyValidator();
  bool isValidForm = false;

  late final formKey = GlobalKey<FormState>();
  late final filenameController = TextEditingController();

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
                    // key: const Key('google_drive_configuration_screen_filename_text_field_key'),
                    hint: context.fileNameTextFieldHint,
                    tooltipMessage: context.fileNameTooltip,
                    controller: filenameController,
                    validator: noEmptyValidator,
                    inputFormatter: null,
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: CommonSize.indent2x),
              CupertinoButton(
                onPressed: isValidForm ? () => _onSave(context) : null,
                child: Text(context.saveButtonTitle),
              ),
              const SizedBox(height: CommonSize.indent2x),
            ],
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
            filename: filenameController.text,
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
