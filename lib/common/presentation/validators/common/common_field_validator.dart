import 'package:pwd/common/presentation/validators/common/common_field_validator_message_provider.dart';
import 'package:pwd/common/presentation/validators/common/validator.dart';

export 'common_field_input_formatter.dart';
export 'common_field_validator_message_provider.dart';

abstract class CommonFieldValidator extends Validator {
  String get pattern;

  bool get isRequired => true;

  int? get minLength;

  int? get maxLength;

  const CommonFieldValidator();

  @override
  CommonFieldValidatorError? call(String? str) {
    if (str == null || str.isEmpty) {
      return isRequired ? CommonFieldValidatorError.empty() : null;
    } else if (minLength != null && minLength! > 0 && str.length < minLength!) {
      return CommonFieldValidatorError.minLength(minLength: minLength!);
    } else if (maxLength != null && maxLength! > 0 && str.length > maxLength!) {
      return CommonFieldValidatorError.maxLength(maxLength: maxLength!);
    } else if (pattern.isNotEmpty && !RegExp(pattern).hasMatch(str)) {
      return CommonFieldValidatorError.format();
    } else {
      return null;
    }
  }
}

abstract class CommonFieldValidatorError extends ValidatorError
    with CommonFieldValidatorMessageProvider {
  CommonFieldValidatorError() : super();

  factory CommonFieldValidatorError.empty() = CommonFieldValidatorErrorEmpty;
  factory CommonFieldValidatorError.minLength({required int minLength}) =
      CommonFieldValidatorErrorMinLength;
  factory CommonFieldValidatorError.maxLength({required int maxLength}) =
      CommonFieldValidatorErrorMaxLength;
  factory CommonFieldValidatorError.format() = CommonFieldValidatorErrorFormat;
}

class CommonFieldValidatorErrorEmpty extends CommonFieldValidatorError {
  CommonFieldValidatorErrorEmpty();
}

class CommonFieldValidatorErrorMaxLength extends CommonFieldValidatorError {
  final int maxLength;
  CommonFieldValidatorErrorMaxLength({required this.maxLength});
}

class CommonFieldValidatorErrorMinLength extends CommonFieldValidatorError {
  final int minLength;
  CommonFieldValidatorErrorMinLength({required this.minLength});
}

class CommonFieldValidatorErrorFormat extends CommonFieldValidatorError {
  CommonFieldValidatorErrorFormat();
}
