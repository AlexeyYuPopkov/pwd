import 'package:flutter/material.dart';

@immutable
class ShimmerTheme extends ThemeExtension<ShimmerTheme> {
  final Color baseColor;
  final Color highlightColor;

  const ShimmerTheme({
    required this.baseColor,
    required this.highlightColor,
  });

  factory ShimmerTheme.lightTheme() {
    return ShimmerTheme(
      baseColor: const Color.fromARGB(255, 146, 195, 172).withOpacity(0.5),
      highlightColor: Colors.white,
    );
  }

  factory ShimmerTheme.defaultTheme() {
    return ShimmerTheme.lightTheme();
  }

  static ShimmerTheme of(BuildContext context) =>
      Theme.of(context).extension<ShimmerTheme>()!;

  @override
  ShimmerTheme lerp(ThemeExtension<ShimmerTheme>? other, double t) {
    if (other is! ShimmerTheme) {
      return this;
    }
    return ShimmerTheme(
      baseColor: Color.lerp(baseColor, other.baseColor, t) ?? baseColor,
      highlightColor:
          Color.lerp(highlightColor, other.highlightColor, t) ?? highlightColor,
    );
  }

  @override
  ShimmerTheme copyWith({
    Color? baseColor,
    Color? highlightColor,
  }) =>
      ShimmerTheme(
        baseColor: baseColor ?? this.baseColor,
        highlightColor: highlightColor ?? this.highlightColor,
      );
}
