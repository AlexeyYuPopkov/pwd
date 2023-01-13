import 'package:flutter/material.dart';

final lightThemeData = ThemeData.light().copyWith(
  appBarTheme: const AppBarTheme(elevation: 0),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.lightGreenAccent,
  ),
);
