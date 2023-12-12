import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? iconData;

  const AppBarButton({
    super.key,
    this.onPressed,
    required this.iconData,
  });

  Color get iconColor =>
      onPressed == null ? Colors.white.withOpacity(0.4) : Colors.white;

  @override
  Widget build(BuildContext context) => CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Icon(iconData, color: iconColor),
      );
}
