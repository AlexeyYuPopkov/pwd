import 'package:pwd/common/presentation/validators/validator.dart';
export 'no_empty_validator_message_provider.dart';

// No empty validator
class NoEmptyValidator extends Validator {
  const NoEmptyValidator();

  @override
  NoEmptyValidatorError? call(String? str) {
    if (str == null || str.isEmpty) {
      return NoEmptyValidatorError();
    }
    return null;
  }
}

class NoEmptyValidatorError extends Error {
  NoEmptyValidatorError() : super();
}
