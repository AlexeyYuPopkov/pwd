import 'package:pwd/common/presentation/validators/common/common_field_validator.dart';

class NoEmptyValidator extends CommonFieldValidator {
  const NoEmptyValidator();

  @override
  bool get isRequired => true;

  @override
  int? get minLength => null;

  @override
  int? get maxLength => null;

  @override
  String get pattern => '';
}
