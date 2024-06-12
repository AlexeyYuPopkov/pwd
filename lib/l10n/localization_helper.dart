import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pwd/l10n/gen_l10n/localization.dart';

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
