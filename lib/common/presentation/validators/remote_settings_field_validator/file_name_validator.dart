import 'package:pwd/common/presentation/validators/common/common_field_validator.dart';

class FileNameValidator extends CommonFieldValidator {
  static const overridedEditingPattern = r'[a-zA-Z0-9_.]*';
  static const overridedPattern = '${r'^'}$overridedEditingPattern${r'$'}';

  const FileNameValidator();

  @override
  bool get isRequired => true;

  @override
  int? get minLength => null;

  @override
  int? get maxLength => null;

  @override
  String get pattern => overridedPattern;
}

class FileNameInputFormatter extends CommonFieldInputFormatter {
  const FileNameInputFormatter();

  @override
  String get pattern => FileNameValidator.overridedEditingPattern;
}
