import 'package:flutter/material.dart';

import 'package:pwd/common/presentation/validators/ipv4_validator/didgits_only_validator.dart';
import 'package:pwd/common/presentation/validators/ipv4_validator/ipv4_validator.dart';
import 'package:pwd/l10n/gen_l10n/localization.dart';
import 'package:pwd/theme/common_size.dart';

final class DeveloperSettingsProxyForm extends StatefulWidget {
  final void Function(DeveloperSettingsProxyFormData) onSave;

  const DeveloperSettingsProxyForm({
    super.key,
    required this.onSave,
  });

  @override
  State<DeveloperSettingsProxyForm> createState() =>
      DeveloperSettingsProxyFormState();
}

final class DeveloperSettingsProxyFormState
    extends State<DeveloperSettingsProxyForm> {
  late final formKey = GlobalKey<FormState>();
  late final proxyController = TextEditingController();
  late final portController = TextEditingController();

  final didgitsOnlyValidator = const DidgitsOnlyValidator(isRequired: false);
  final didgitsOnlyInputFormatter = const DidgitsOnlyInputFormatter();

  final ipValidator = const Ipv4Validator(isRequired: false);
  final ipInputFormatter = const Ipv4InputFormatter();

  @override
  void dispose() {
    proxyController.dispose();
    portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      onChanged: () {
        widget.onSave(
          DeveloperSettingsProxyFormData(
            ip: proxyController.text,
            port: portController.text,
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: proxyController,
            decoration: InputDecoration(
              labelText: context.proxyLabelTitle,
            ),
            keyboardType: TextInputType.number,
            validator: (str) => ipValidator(str)?.message(context),
            inputFormatters: ipInputFormatter(),
          ),
          const SizedBox(height: CommonSize.indent2x),
          TextFormField(
            controller: portController,
            decoration: InputDecoration(
              labelText: context.portLabelTitle,
            ),
            keyboardType: TextInputType.number,
            validator: (str) => didgitsOnlyValidator(str)?.message(context),
            inputFormatters: didgitsOnlyInputFormatter(),
          ),
        ],
      ),
    );
  }

  bool validate() {
    final isValid = formKey.currentState?.validate() == true;

    if (isValid) {
      formKey.currentState?.save();
    }

    return isValid;
  }

  DeveloperSettingsProxyFormData get data => DeveloperSettingsProxyFormData(
        ip: proxyController.text,
        port: portController.text,
      );
  void setDeveloperSettingsProxyFormData(DeveloperSettingsProxyFormData data) {
    proxyController.text = data.ip;
    portController.text = data.port;
  }

  void onSave(BuildContext context) {
    if (validate()) {
      widget.onSave(data);
    }
  }
}

final class DeveloperSettingsProxyFormData {
  final String ip;
  final String port;

  DeveloperSettingsProxyFormData({required this.ip, required this.port});
}

// Localization
extension on BuildContext {
  Localization get localization => Localization.of(this)!;
  String get proxyLabelTitle =>
      localization.developerSettingsScreenProxyFormProxyLabel;
  String get portLabelTitle =>
      localization.developerSettingsScreenProxyFormPortLabel;
}
