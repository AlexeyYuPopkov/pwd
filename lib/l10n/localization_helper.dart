import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/localization.dart' as localization;

typedef Localization = localization.Localization;

final class LocalizationHelper {
  static Iterable<LocalizationsDelegate<dynamic>>? get localizationsDelegates =>
      [
        Localization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  static Iterable<Locale> get supportedLocales => const [
        /// English
        Locale('en'),

        /// Russian
        Locale('ru'),
      ];
}

extension LocalizationGetter on BuildContext {
  Localization get localization => (Localization.of(this))!;
}
