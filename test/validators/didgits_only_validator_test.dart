import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/presentation/validators/common/common_field_validator.dart';
import 'package:pwd/common/presentation/validators/ipv4_validator/didgits_only_validator.dart';

import '../test_tools/test_tools.dart';

void main() {
  group('Test Remote settings field validator', () {
    const validator = DidgitsOnlyValidator(isRequired: false);

    test('Check valid values', () {
      final validValues = [
        '',
        '127',
        '19216819',
      ];

      for (var src in validValues) {
        expect(validator.isValid(src), true);
      }
    });

    test('Check invalid values', () {
      final invalidValues = [
        _Pair('Абвгд', CommonFieldValidatorError.format()),
        _Pair('127.0.0.1', CommonFieldValidatorError.format()),
        _Pair('a1', CommonFieldValidatorError.format()),
      ];

      for (var src in invalidValues) {
        expect(validator.isValid(src.candidate), false);

        expect(
          validator.call(src.candidate).runtimeType.toString(),
          src.error.runtimeType.toString(),
        );
      }
    });
  });

  group('Test Remote settings field validator input formatter', () {
    const inputFormatter = DidgitsOnlyInputFormatter();

    final inputFormatters = inputFormatter.call();

    test('Check valid inputs', () {
      const testItems = [
        Pair('', ''),
        Pair('', '1'),
        Pair('12345', '123456'),
      ];

      for (final item in testItems) {
        expect(
          InputFormatterTestTools.inputFormattersOutput(
                inputFormatters,
                TextEditingValue(text: item.first),
                TextEditingValue(text: item.second),
              ).text ==
              item.second,
          true,
        );
      }
    });

    test('Check invalid inputs', () {
      const testItems = [
        Pair('', '.'),
        Pair('123', '123a'),
      ];

      for (final item in testItems) {
        expect(
          InputFormatterTestTools.inputFormattersOutput(
                inputFormatters,
                TextEditingValue(text: item.first),
                TextEditingValue(text: item.second),
              ).text ==
              item.first,
          true,
        );
      }
    });
  });
}

typedef _Pair = ErrorPair<String, CommonFieldValidatorError>;
