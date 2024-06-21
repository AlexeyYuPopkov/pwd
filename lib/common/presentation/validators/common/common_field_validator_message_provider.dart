import 'package:flutter/material.dart';
import 'package:pwd/l10n/localization_helper.dart';

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
  String get notEmptyMessage =>
      localization.commonFieldValidatorMessageNotEmpty;
  String get wrongFormatMessage =>
      localization.commonFieldValidatorMessageWrongFormat;
  String validationMinLength(int maxLength) =>
      localization.commonFieldValidatorMessageMinLength;
  String validationMaxLength(int maxLength) =>
      localization.commonFieldValidatorMessageMaxLength;
}
