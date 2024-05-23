import 'package:flutter/material.dart';
import 'package:pwd/unauth/presentation/router/custom_page_route.dart';

@immutable
class CustomPageTransistionsTheme
    extends ThemeExtension<CustomPageTransistionsTheme> {
  final PageTransitionsTheme fade;
  final Duration fadeDuration;

  const CustomPageTransistionsTheme({
    required this.fade,
    required this.fadeDuration,
  });

  factory CustomPageTransistionsTheme.create() => CustomPageTransistionsTheme(
        fade: createForAllWith(const FadeTransitionBuilder()),
        fadeDuration: Durations.medium2,
      );

  static CustomPageTransistionsTheme of(BuildContext context) =>
      Theme.of(context).extension<CustomPageTransistionsTheme>()!;

  @override
  CustomPageTransistionsTheme lerp(
    ThemeExtension<CustomPageTransistionsTheme>? other,
    double t,
  ) =>
      this;

  static PageTransitionsTheme createForAllWith(
    PageTransitionsBuilder builder,
  ) =>
      PageTransitionsTheme(
        builders: {
          TargetPlatform.android: builder,
          TargetPlatform.iOS: builder,
          TargetPlatform.macOS: builder,
          TargetPlatform.windows: builder,
          TargetPlatform.linux: builder,
        },
      );

  @override
  ThemeExtension<CustomPageTransistionsTheme> copyWith({
    PageTransitionsTheme? fade,
    Duration? fadeDuration,
  }) =>
      CustomPageTransistionsTheme(
        fade: fade ?? this.fade,
        fadeDuration: fadeDuration ?? this.fadeDuration,
      );
}
