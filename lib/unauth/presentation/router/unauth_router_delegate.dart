import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/fade_animation_page.dart';
import 'package:pwd/common/presentation/router/base_router_delegate.dart';
import 'package:pwd/unauth/presentation/pin_page/pin_page.dart';

class UnauthRouterPagePath {
  static const pin = 'pin';
}

class UnauthRouterDelegate extends BaseRouterDelegate {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  UnauthRouterDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  @override
  List<Page> get initialPages => [
        FadeAnimationPage(
          child: PinPage(onRoute: onRoute),
          name: UnauthRouterPagePath.pin,
        )
      ];

  @override
  Future onRoute(BuildContext context, Object action) async {}
}
