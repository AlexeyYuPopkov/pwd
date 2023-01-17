import 'package:pwd/common/presentation/validators/common/common_field_validator.dart';

class RemoteSettingsFieldValidator extends CommonFieldValidator {
  static const overridedEditingPattern = r'[a-zA-Z0-9_]*';
  static const overridedPattern = '${r'^'}$overridedEditingPattern${r'$'}';

  const RemoteSettingsFieldValidator();

  @override
  bool get isRequired => true;

  @override
  int? get minLength => null;

  @override
  int? get maxLength => null;

  @override
  String get pattern => overridedPattern;
}

class RemoteSettingsFieldInputFormatter extends CommonFieldInputFormatter {
  const RemoteSettingsFieldInputFormatter();

  @override
  String get pattern => RemoteSettingsFieldValidator.overridedEditingPattern;
}
