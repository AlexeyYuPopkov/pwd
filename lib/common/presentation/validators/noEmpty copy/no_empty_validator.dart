import 'package:pwd/common/presentation/validators/common/validator.dart';
import 'package:pwd/common/presentation/validators/noEmpty%20copy/no_empty_validator_message_provider.dart';

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

class NoEmptyValidatorError extends ValidatorError
    with NoEmptyValidatorMessageProvider {
  NoEmptyValidatorError();
}
