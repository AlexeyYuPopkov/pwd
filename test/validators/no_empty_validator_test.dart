import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/presentation/validators/common/common_field_validator.dart';
import 'package:pwd/common/presentation/validators/noEmpty/no_empty_validator.dart';

import '../test_tools/test_tools.dart';

void main() {
  group('Test inn validator', () {
    const validator = NoEmptyValidator();

    test('Check valid values', () {
      final validValues = [
        '01234567890123',
        'Lorem ipsum',
        List.filled(50, '0').join(),
      ];

      for (var src in validValues) {
        expect(validator.isValid(src), true);
      }
    });

    test('Check invalid values', () {
      final invalidValues = [
        _Pair('', CommonFieldValidatorError.empty()),
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
}

typedef _Pair = ErrorPair<String, CommonFieldValidatorError>;
