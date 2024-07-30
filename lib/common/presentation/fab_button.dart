import 'package:flutter/material.dart';
import 'package:pwd/theme/common_size.dart';
import 'package:pwd/theme/common_theme.dart';

final class FloatingButton extends StatelessWidget {
  final VoidCallback? onTap;
  const FloatingButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: commonTheme.highlightColor,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        height: CommonSize.rowHeight,
        width: CommonSize.rowHeight,
        child: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onTap,
        ),
      ),
    );
  }
}
