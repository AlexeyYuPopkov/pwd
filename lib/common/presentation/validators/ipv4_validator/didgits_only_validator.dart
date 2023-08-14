import 'package:pwd/common/presentation/validators/common/common_field_validator.dart';

class DidgitsOnlyValidator extends CommonFieldValidator {
  @override
  final bool isRequired;

  static const overridedEditingPattern = r'\d';
  static const overridedPattern = r'^\d{0,}$';

  const DidgitsOnlyValidator({
    required this.isRequired,
  });

  @override
  int? get minLength => null;

  @override
  int? get maxLength => null;

  @override
  String get pattern => overridedPattern;
}

class DidgitsOnlyInputFormatter extends CommonFieldInputFormatter {
  const DidgitsOnlyInputFormatter();

  @override
  String get pattern => DidgitsOnlyValidator.overridedEditingPattern;
}
