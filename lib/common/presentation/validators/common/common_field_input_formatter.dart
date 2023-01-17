import 'package:flutter/services.dart';

abstract class CommonFieldInputFormatter {
  String get pattern;

  int? get maxLength => null;

  const CommonFieldInputFormatter();

  List<TextInputFormatter> call() => [
        if (pattern.isNotEmpty)
          FilteringTextInputFormatter.allow(RegExp(pattern)),
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ];
}
