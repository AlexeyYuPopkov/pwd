import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/fab_button.dart';

mixin AdaptiveLayoutHelper {
  Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  bool isLandscape(BuildContext context) {
    final size = screenSize(context);
    return size.width > size.height;
  }

  Widget? createFab(BuildContext context) => isLandscape(context)
      ? null
      : FloatingButton(
          onTap: () => Scaffold.of(context).openDrawer(),
        );
}
