import 'package:flutter/services.dart';

class Pair<K, V> {
  final K first;
  final V second;

  const Pair(
    this.first,
    this.second,
  );
}

class ErrorPair<K, V> {
  final K candidate;
  final V error;

  const ErrorPair(
    this.candidate,
    this.error,
  );
}

class InputFormatterTestTools {
  static TextEditingValue inputFormattersOutput(
    List<TextInputFormatter> inputFormatters,
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final result = inputFormatters.fold<TextEditingValue>(
      newValue,
      (
        TextEditingValue resultValue,
        TextInputFormatter formatter,
      ) =>
          formatter.formatEditUpdate(oldValue, resultValue),
    );
    return result;
  }
}
