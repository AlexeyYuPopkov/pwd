import 'package:pwd/common/presentation/validators/common/common_field_validator.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/remote_settings_field_validator.dart';

class RemoteSettingsFieldValidatorNotRequired extends CommonFieldValidator {
  static const overridedEditingPattern =
      RemoteSettingsFieldValidator.overridedEditingPattern;
  static const overridedPattern = RemoteSettingsFieldValidator.overridedPattern;

  const RemoteSettingsFieldValidatorNotRequired();

  @override
  bool get isRequired => false;

  @override
  int? get minLength => null;

  @override
  int? get maxLength => null;

  @override
  String get pattern => overridedPattern;
}

class RemoteSettingsFieldNotRequiredInputFormatter
    extends RemoteSettingsFieldInputFormatter {
  const RemoteSettingsFieldNotRequiredInputFormatter();
}
