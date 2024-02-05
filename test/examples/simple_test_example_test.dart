import 'package:flutter_test/flutter_test.dart';

abstract base class ValidatorVariant {
  Object? error(String? str);

  bool isValid(String? str) => error(str) == null;
}

final class CommonValidatorVariantMessages {
  final String maxLength;
  final String minLength;
  final String isRequired;
  final String pattern;

  CommonValidatorVariantMessages({
    required this.maxLength,
    required this.minLength,
    required this.isRequired,
    required this.pattern,
  });

  factory CommonValidatorVariantMessages.empty() =>
      CommonValidatorVariantMessages(
        maxLength: '',
        minLength: '',
        isRequired: '',
        pattern: '',
      );
}

final class CommonValidatorVariant extends ValidatorVariant {
  final int? maxLength;
  final int? minLength;
  final bool isRequired;
  final String pattern;

  final CommonValidatorVariantMessages messages;

  CommonValidatorVariant({
    this.maxLength,
    this.minLength,
    this.isRequired = false,
    this.pattern = '',
    required this.messages,
  });

  @override
  CommonValidatorVariantError? error(String? str) {
    if (str == null || str.isEmpty) {
      return isRequired ? RequiredError() : null;
    } else if (minLength != null && minLength! > 0 && str.length < minLength!) {
      return MinLengthError(length: minLength!);
    } else if (maxLength != null && maxLength! > 0 && str.length > maxLength!) {
      return MaxLengthError(length: maxLength!);
    } else if (pattern.isNotEmpty && !RegExp(pattern).hasMatch(str)) {
      return FormatError();
    } else {
      return null;
    }
  }

  String message(CommonValidatorVariantError error) {
    switch (error) {
      case MinLengthError():
        return messages.minLength;
      case MaxLengthError():
        return messages.maxLength;
      case FormatError():
        return messages.pattern;
      case RequiredError():
        return messages.isRequired;
    }
  }
}

sealed class CommonValidatorVariantError {}

final class MinLengthError extends CommonValidatorVariantError {
  final int length;

  MinLengthError({required this.length});
}

final class MaxLengthError extends CommonValidatorVariantError {
  final int length;

  MaxLengthError({required this.length});
}

final class FormatError extends CommonValidatorVariantError {}

final class RequiredError extends CommonValidatorVariantError {}

void main() {
  group('CommonValidatorVariant', () {
    final validator = CommonValidatorVariant(
      minLength: 5,
      maxLength: 10,
      isRequired: true,
      pattern: r'^[a-zA-Z0-9]*$',
      messages: CommonValidatorVariantMessages.empty(),
    );

    test('valid', () {
      expect(validator.error('12345'), null);
    });

    test('invalid', () {
      expect(validator.error(null), isA<RequiredError>());
      expect(validator.error(''), isA<RequiredError>());
      expect(validator.error('1234'), isA<MinLengthError>());
      expect(validator.error('12345678901'), isA<MaxLengthError>());
      expect(validator.error('1 2 3 4'), isA<FormatError>());
    });
  });
}
