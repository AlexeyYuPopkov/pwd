import 'package:pwd/common/presentation/validators/common/common_field_validator.dart';

class Ipv4Validator extends CommonFieldValidator {
  @override
  final bool isRequired;

  static const overridedEditingPattern = r'(\d{1,3}\.{0,1}){0,3}(\d{1,3}){0,1}';
  static const overridedPattern = r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$';
  const Ipv4Validator({
    required this.isRequired,
  });

  @override
  int? get minLength => null;

  @override
  int? get maxLength => null;

  @override
  String get pattern => overridedPattern;
}

class Ipv4InputFormatter extends CommonFieldInputFormatter {
  const Ipv4InputFormatter();

  @override
  String get pattern => Ipv4Validator.overridedEditingPattern;
}
