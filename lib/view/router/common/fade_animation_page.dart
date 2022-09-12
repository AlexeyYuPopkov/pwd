/*
 * Copyright (c) 2022-2022.
 * System Technologies <support@st.by>.
 * Alexey Popkov <popkov_oy@st.by> is author  this file.
 * The file fade_animation_page.dart is part of UnifiedProject.
 * UnifiedProject can not be copied and/or distributed without the express permission of System Technologies.
 */

import 'package:flutter/material.dart';

class FadeAnimationPage extends Page {
  final Widget child;

  const FadeAnimationPage({
    LocalKey? key,
    required this.child,
    String? name,
    Object? arguments,
    String? restorationId,
  }) : super(
          key: key,
          name: name,
          arguments: arguments,
          restorationId: restorationId,
        );

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        var curveTween = CurveTween(curve: Curves.easeIn);

        return FadeTransition(
          opacity: animation.drive(curveTween),
          child: child,
        );
      },
    );
  }
}
