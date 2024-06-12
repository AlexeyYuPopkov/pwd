import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/l10n/localization_helper.dart';
import 'package:pwd/theme/theme_data.dart';

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

final class CreateApp {
  static Widget createMaterialApp({required Widget child}) {
    return MaterialApp(
      theme: lightThemeData,
      localizationsDelegates: LocalizationHelper.localizationsDelegates,
      supportedLocales: LocalizationHelper.supportedLocales,
      home: BlockingLoadingIndicator(
        child: child,
      ),
    );
  }
}
