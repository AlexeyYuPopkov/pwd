import 'package:flutter/material.dart';
import 'package:pwd/theme/shimmer_theme.dart';
import 'package:shimmer/shimmer.dart';

final class CommonShimmer extends StatelessWidget {
  final bool isLoading;
  final ShimmerTheme? style;
  final Widget child;

  const CommonShimmer({
    super.key,
    this.isLoading = true,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? ShimmerTheme.of(context);

    return isLoading
        ? Shimmer.fromColors(
            baseColor: style.baseColor,
            highlightColor: style.highlightColor,
            period: const Duration(milliseconds: 1000),
            child: ColoredBox(color: style.baseColor, child: child),
          )
        : child;
  }
}
