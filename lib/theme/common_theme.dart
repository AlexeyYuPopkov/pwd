import 'package:flutter/material.dart';

@immutable
class CommonTheme extends ThemeExtension<CommonTheme> {
  final Color? primaryTextColor;
  final Color? highlightColor;
  final ButtonStyle? iconButtonStyle;

  const CommonTheme({
    this.primaryTextColor,
    this.highlightColor,
    this.iconButtonStyle,
  });

  static CommonTheme of(BuildContext context) =>
      Theme.of(context).extension<CommonTheme>()!;

  factory CommonTheme.lightTheme() {
    const primaryTextColor = Colors.black87;
    return CommonTheme(
      primaryTextColor: primaryTextColor,
      highlightColor: const Color(0xeeD8E7CC),
      iconButtonStyle: ButtonStyle(
        elevation: WidgetStateProperty.all(0.0),
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        iconColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return primaryTextColor.withOpacity(0.5);
            } else if (states.contains(WidgetState.pressed)) {
              return primaryTextColor.withOpacity(0.5);
            }
            return primaryTextColor;
          },
        ),
        overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
      ),
    );
  }

  factory CommonTheme.darkTheme() => CommonTheme.lightTheme();

  @override
  CommonTheme lerp(ThemeExtension<CommonTheme>? other, double t) {
    if (other is! CommonTheme) {
      return this;
    }
    return CommonTheme(
      primaryTextColor: Color.lerp(
        primaryTextColor,
        other.primaryTextColor,
        t,
      ),
      iconButtonStyle: ButtonStyle.lerp(
        iconButtonStyle,
        other.iconButtonStyle,
        t,
      ),
    );
  }

  @override
  CommonTheme copyWith({
    Color? primaryTextColor,
    ButtonStyle? iconButtonStyle,
  }) {
    return CommonTheme(
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      iconButtonStyle: iconButtonStyle ?? this.iconButtonStyle,
    );
  }
}
