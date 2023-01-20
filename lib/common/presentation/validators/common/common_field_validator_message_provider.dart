import 'package:flutter/material.dart';

import 'common_field_validator.dart';

mixin CommonFieldValidatorMessageProvider {
  String? message(
    BuildContext context, {
    CommonFieldValidatorErrorMessages messages =
        const CommonFieldValidatorErrorMessages(),
  }) {
    if (this is CommonFieldValidatorErrorEmpty) {
      return messages.validationNotEmpty ?? context.notEmptyMessage;
    } else if (this is CommonFieldValidatorErrorMinLength) {
      final error = this as CommonFieldValidatorErrorMinLength;
      return messages.validationMinLength ??
          context.validationMinLength(error.minLength);
    } else if (this is CommonFieldValidatorErrorMaxLength) {
      final error = this as CommonFieldValidatorErrorMaxLength;
      return messages.validationMaxLength ??
          context.validationMaxLength(error.maxLength);
    } else if (this is CommonFieldValidatorErrorFormat) {
      return messages.validationWrongFormat ?? context.wrongFormatMessage;
    }

    return null;
  }
}

class CommonFieldValidatorErrorMessages {
  final String? validationNotEmpty;
  final String? validationMinLength;
  final String? validationMaxLength;
  final String? validationWrongFormat;

  const CommonFieldValidatorErrorMessages({
    this.validationNotEmpty,
    this.validationMinLength,
    this.validationMaxLength,
    this.validationWrongFormat,
  });
}

// Localization
extension on BuildContext {
  String get notEmptyMessage => 'The field should not be empty';

  String get wrongFormatMessage => 'Wrong symbols founded';

  String validationMinLength(int maxLength) => 'Wrong length';

  String validationMaxLength(int maxLength) => 'Wrong length';
}
