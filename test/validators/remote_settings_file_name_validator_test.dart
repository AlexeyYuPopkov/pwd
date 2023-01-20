import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/presentation/validators/common/common_field_validator.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/remote_settings_file_name_validator.dart';

import '../test_tools/test_tools.dart';

void main() {
  group('Test Remote settings field validator', () {
    const validator = RemoteSettingsFileNameValidator();

    test('Check valid values', () {
      final validValues = [
        '01234567890123',
        'Lorem_ipsum_123',
        'Lorem_ipsum_123.json',
        'Lorem_ipsum_123.j',
        List.filled(50, '0').join(),
      ];

      for (var src in validValues) {
        expect(validator.isValid(src), true);
      }
    });

    test('Check invalid values', () {
      final invalidValues = [
        _Pair('', CommonFieldValidatorError.empty()),
        _Pair('Абвгд', CommonFieldValidatorError.format()),
        _Pair('Lorem_ipsum_123#', CommonFieldValidatorError.format()),
        _Pair('*Lorem_ipsum_123', CommonFieldValidatorError.format()),
        _Pair('Lorem/ipsum_123', CommonFieldValidatorError.format()),
        _Pair('Lorem_ipsum_123.', CommonFieldValidatorError.format()),
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
    const inputFormatter = RemoteSettingsFileNameInputFormatter();

    final inputFormatters = inputFormatter.call();

    test('Check valid inputs', () {
      const testItems = [
        Pair('', '1'),
        Pair('abc', 'abc1'),
        Pair('Lorem', 'Lorem_'),
        Pair('Lorem', 'Lorem.'),
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
        Pair('', '@'),
        Pair('abc', 'abcЫ'),
        Pair('abc', 'abc*'),
        Pair('abc', 'abc/'),
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
