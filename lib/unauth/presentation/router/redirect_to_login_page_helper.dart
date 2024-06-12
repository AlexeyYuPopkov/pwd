import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin RedirectToLoginPageHelper {
  bool Function() get isAuthorized;

  FutureOr<String?> redirectToLoginPage(
    BuildContext context,
    GoRouterState state,
  ) =>
      isAuthorized() ? null : '/';
}
