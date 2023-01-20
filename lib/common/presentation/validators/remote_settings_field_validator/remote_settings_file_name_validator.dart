import 'package:pwd/common/presentation/validators/common/common_field_validator.dart';

class RemoteSettingsFileNameValidator extends CommonFieldValidator {
  static const overridedEditingPattern = r'[a-zA-Z0-9_.]*';
  static const overridedPattern =
      '${r'(?!.*[.]{2,})(?!.*[.]$)'}${r'^'}$overridedEditingPattern${r'$'}';

  const RemoteSettingsFileNameValidator();

  @override
  bool get isRequired => true;

  @override
  int? get minLength => null;

  @override
  int? get maxLength => null;

  @override
  String get pattern => overridedPattern;
}

class RemoteSettingsFileNameInputFormatter extends CommonFieldInputFormatter {
  const RemoteSettingsFileNameInputFormatter();

  @override
  String get pattern => RemoteSettingsFileNameValidator.overridedEditingPattern;
}
