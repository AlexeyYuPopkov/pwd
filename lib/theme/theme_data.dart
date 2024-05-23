import 'package:flutter/material.dart';
import 'package:pwd/theme/common_theme.dart';
import 'package:pwd/theme/custom_page_transistions_theme.dart';
import 'package:pwd/theme/shimmer_theme.dart';
import 'package:pwd/theme/text_sizes.dart';

const _textColor = Color.fromARGB(255, 66, 66, 66);

final lightThemeData = ThemeData.light().copyWith(
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Color(0xFFFFFFFF),
  ),
  colorScheme: lightColorScheme,
  navigationRailTheme: const NavigationRailThemeData(
    backgroundColor: Colors.white,
  ),
  outlinedButtonTheme: const OutlinedButtonThemeData(
    style: ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(150, 44)),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: TextSizes.normal,
        ),
      ),
    ),
  ),
  textTheme: const TextTheme().copyWith(
    titleLarge: const TextStyle(
      fontSize: TextSizes.large,
      color: _textColor,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: const TextStyle(
      fontSize: TextSizes.titleMedium,
      color: _textColor,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: const TextStyle(
      fontSize: TextSizes.normal,
      color: _textColor,
    ),
    bodyLarge: const TextStyle(
      fontSize: TextSizes.normal,
      color: _textColor,
    ),
    bodyMedium: const TextStyle(
      fontSize: TextSizes.medium,
      color: _textColor,
    ),
    bodySmall: const TextStyle(
      fontSize: TextSizes.small,
      color: _textColor,
    ),
  ),
  dialogTheme: const DialogTheme(
    titleTextStyle: TextStyle(
      fontSize: TextSizes.titleMedium,
      color: _textColor,
      fontWeight: FontWeight.w500,
    ),
  ),
  extensions: [
    CommonTheme.lightTheme(),
    ShimmerTheme.lightTheme(),
    CustomPageTransistionsTheme.create(),
  ],
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1D6D00),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFA0F87E),
  onPrimaryContainer: Color(0xFF042100),
  secondary: Color(0xFF54624D),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD8E7CC),
  onSecondaryContainer: Color(0xFF131F0E),
  tertiary: Color(0xFF386667),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFBCEBED),
  onTertiaryContainer: Color(0xFF002021),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1A1C18),
  surfaceContainerHighest: Color(0xFFDFE4D7),
  onSurfaceVariant: Color(0xFF43483F),
  outline: Color(0xFF73796E),
  onInverseSurface: Color(0xFFF1F1EA),
  inverseSurface: Color(0xFF2F312D),
  inversePrimary: Color(0xFF85DB65),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF1D6D00),
  outlineVariant: Color(0xFFC3C8BB),
  scrim: Color(0xFF000000),
);
