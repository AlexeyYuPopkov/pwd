import 'package:flutter/material.dart';
import 'package:pwd/theme/common_theme.dart';
import 'package:pwd/theme/shimmer_theme.dart';
import 'package:pwd/theme/text_sizes.dart';

/// Colors.grey.shade800;
const _textColor = Color.fromARGB(255, 66, 66, 66);

final lightThemeData = ThemeData.light().copyWith(
  appBarTheme: const AppBarTheme(elevation: 0),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.white,
  ),
  navigationRailTheme: const NavigationRailThemeData(
    backgroundColor: Colors.white,
  ),
  outlinedButtonTheme: const OutlinedButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStatePropertyAll(Size(150, 44)),
      textStyle: MaterialStatePropertyAll(
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
  extensions: [
    CommonTheme.lightTheme(),
    ShimmerTheme.lightTheme(),
  ],
);
