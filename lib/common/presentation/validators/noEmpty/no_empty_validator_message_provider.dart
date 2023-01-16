import 'package:flutter/material.dart';

import 'no_empty_validator.dart';

extension NoEmptyValidatorMessageProvider on NoEmptyValidatorError {
  String? message(BuildContext context) {
    return context.empty;
  }
}

// Localization
extension on BuildContext {
  String get empty => 'The field should not be empty';
}
