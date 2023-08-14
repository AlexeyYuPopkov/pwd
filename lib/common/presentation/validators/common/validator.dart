import 'package:flutter/widgets.dart';

abstract class Validator {
  const Validator();

  ValidatorError? call(String? str);

  bool isValid(String? str) => call(str) == null;
}

abstract class ValidatorError extends Error {
  ValidatorError();

  String? message(BuildContext context) => null;
}
