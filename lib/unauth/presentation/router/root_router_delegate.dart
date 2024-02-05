import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/user_session.dart';
import 'package:pwd/common/domain/usecases/user_session_provider_usecase.dart';
import 'package:pwd/common/presentation/di/app_di_modules.dart';
import 'package:pwd/common/presentation/router/base_router_delegate.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_page.dart';

import 'package:pwd/unauth/presentation/pin_page/pin_page.dart';

import 'configuration_router_delegate.dart';

final class RootRouterDelegatePath {
  static const root = '/';
  static const home = 'home';
  static const pin = 'pin';
  static const configuration = 'configuration';
}

final class RootRouterDelegate extends BaseRouterDelegate {
  final UserSessionProviderUsecase userSessionProviderUsecase;

  late final StreamSubscription userSessionSubscription;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  late final unauthRouterDelegateNavigatorKey = GlobalKey<NavigatorState>();

  RootRouterDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.userSessionProviderUsecase,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    userSessionSubscription = _createSubscriptions();
  }

  @override
  void dispose() {
    userSessionSubscription.cancel();
    super.dispose();
  }

  @override
  List<Page> get initialPages {
    final pages = _createPages(
      userSessionProviderUsecase.curentUserSession,
    );

    return pages.isEmpty ? const [MaterialPage(child: SizedBox())] : pages;
  }

  @override
  Future onRoute(BuildContext context, Object action) async {}
}

extension on RootRouterDelegate {
  List<Page> _createPages(UserSession userSession) {
    switch (userSession) {
      case UnconfiguredSession():
        return [
          MaterialPage(
            child: Router(
              routerDelegate: ConfigurationRouterDelegate(),
            ),
          ),
        ];
      case UnauthorizedSession():
        return [
          MaterialPage(
            child: PinPage(onRoute: onRoute),
            name: RootRouterDelegatePath.pin,
          ),
        ];
      case ValidSession():
        return [
          const MaterialPage(
            child: HomeTabbarPage(),
            name: RootRouterDelegatePath.home,
          ),
        ];
    }
  }

  StreamSubscription _createSubscriptions() {
    return userSessionProviderUsecase.userSession.distinct().asyncMap(
      (userSession) {
        switch (userSession) {
          case UnconfiguredSession():
          case UnauthorizedSession():
            AppDiModules.dropAuthModules();
          case ValidSession():
            AppDiModules.bindAuthModules();
        }

        return userSession;
      },
    ).listen(
      (_) => updateState(),
    );
  }
}
