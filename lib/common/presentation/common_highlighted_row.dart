import 'package:flutter/material.dart';

class CommonHighlightedRow extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Color? color;
  final Color? highlightedColor;

  const CommonHighlightedRow({
    super.key,
    this.onTap,
    this.color = Colors.transparent,
    this.highlightedColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: highlightedColor,
        child: child,
      ),
    );
  }
}

/// RU: Виджет позволяет предотвратить анимацию [InkWell] при нажатии на дочерний интерактивный виджет
/// [onTap] будет вызван лишь для тех областей [child] что обёрнуты в [IgnorePointer].
/// [onPressed] не вызовет [onTap]
///
/// EN: Widget allows you to prevent [InkWell] animation when clicking on a child interactive widget
/// [onTap] calls for wrapped in [IgnorePointer] areas of [child] only.
/// [onPressed] do not call [onTap]
///
/// Example:
///
/// class AnyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return CommonHighlightedBackgroundRow(
///       onTap: () {},
///       child: Row(
///         children: [
///           const IgnorePointer(child: Expanded(child: Text('test text'))),
///           CupertinoButton(
///             onPressed: () {},
///             child: const Text('click me'),
///           ),
///         ],
///       ),
///     );
///   }
/// }

class CommonHighlightedBackgroundRow extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Color? color;
  final Color? highlightedColor;

  const CommonHighlightedBackgroundRow({
    super.key,
    this.onTap,
    this.color = Colors.transparent,
    this.highlightedColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Material(
        color: color,
        child: Stack(
          children: [
            Positioned.fill(
              child: InkWell(
                onTap: onTap,
                splashColor: Colors.transparent,
                highlightColor: highlightedColor,
              ),
            ),
            child,
          ],
        ),
      );
}
