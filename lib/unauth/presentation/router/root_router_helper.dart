import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pwd/home/presentation/home_tabbar/home_router_helper.dart';
import 'package:pwd/theme/custom_page_transistions_theme.dart';
import 'package:pwd/unauth/presentation/pin_page/pin_screen.dart';
import 'package:pwd/unauth/presentation/router/custom_page_route.dart';

import 'redirect_to_login_page_helper.dart';

final class RootRouterHelper with RedirectToLoginPageHelper {
  static final navigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'RootRouterHelper navigatorKey',
  );

  @override
  final bool Function() isAuthorized;

  late final homeRouterHelper = HomeRouterHelper(isAuthorized: isAuthorized);

  RootRouterHelper({required this.isAuthorized});

  late final router = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: '/',
        parentNavigatorKey: navigatorKey,
        pageBuilder: (context, state) {
          final theme = CustomPageTransistionsTheme.of(context);
          return CustomPage(
            key: state.pageKey,
            theme: theme.fade,
            builder: (context) => const PinScreen(),
          );
        },
      ),
      ...homeRouterHelper.route,
    ],
  );
}
