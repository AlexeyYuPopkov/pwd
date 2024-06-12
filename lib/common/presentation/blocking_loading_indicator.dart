import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pwd/theme/common_size.dart';
import 'package:pwd/theme/common_theme.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';

class BlockingLoadingIndicator extends InheritedWidget {
  final streem = BehaviorSubject<bool>.seeded(false);

  bool get isLoading => streem.value;

  set isLoading(bool newValue) => streem.add(newValue);

  BlockingLoadingIndicator({
    super.key,
    required Widget child,
  }) : super(
          child: BlockingLoadingIndicatorWidget(
            child: child,
          ),
        );

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static BlockingLoadingIndicator? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BlockingLoadingIndicator>();
  }

  static BlockingLoadingIndicator of(BuildContext context) {
    final BlockingLoadingIndicator? result = maybeOf(context);
    assert(result != null, 'No BlockingLoadingIndicator found in context');
    return result!;
  }
}

class BlockingLoadingIndicatorWidget extends StatelessWidget {
  final Widget child;

  const BlockingLoadingIndicatorWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          StreamBuilder<bool>(
            initialData: false,
            stream: BlockingLoadingIndicator.of(context).streem.distinct(),
            builder: (context, snapshot) {
              final isLoading = snapshot.data ??
                  BlockingLoadingIndicator.of(context).isLoading;

              final color = isLoading
                  ? CommonTheme.of(context).maskColor ??
                      Colors.black.withOpacity(0.1)
                  : Colors.transparent;

              return Visibility(
                visible: isLoading,
                child: AbsorbPointer(
                  child: ColoredBox(
                    color: color,
                    child: const Center(
                      child: RepaintBoundary(
                        child: DefaultBlockingLoadingIndicator(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
}

final class DefaultBlockingLoadingIndicator extends StatelessWidget {
  const DefaultBlockingLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(CommonSize.cornerRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(CommonSize.indent4x),
        child: Platform.isIOS || Platform.isMacOS
            ? const CupertinoActivityIndicator()
            : const CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
      ),
    );
  }
}
