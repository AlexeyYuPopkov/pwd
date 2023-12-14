import 'package:flutter/material.dart';
import 'package:pwd/theme/common_theme.dart';

class AppBarButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? iconData;

  const AppBarButton({
    super.key,
    this.onPressed,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(iconData),
      style: CommonTheme.of(context).iconButtonStyle,
    );
  }
}
