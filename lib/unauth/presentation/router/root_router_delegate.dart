import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/presentation/di/app_di_modules.dart';
import 'package:pwd/common/presentation/router/base_router_delegate.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_page.dart';
import 'package:pwd/unauth/presentation/pin_page/pin_screen.dart';

final class RootRouterDelegatePath {
  static const root = '/';
  static const home = 'home';
  static const pin = 'pin';
  static const configuration = 'configuration';
}

final class RootRouterDelegate extends BaseRouterDelegate {
  final PinUsecase pinUsecase;

  late final StreamSubscription pinSubscription;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  late final unauthRouterDelegateNavigatorKey = GlobalKey<NavigatorState>();

  RootRouterDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.pinUsecase,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    pinSubscription = _createSubscriptions();
  }

  @override
  void dispose() {
    pinSubscription.cancel();
    super.dispose();
  }

  @override
  List<Page> get initialPages {
    final pages = _createPages(
      pinUsecase.getPin(),
    );

    return pages.isEmpty ? const [MaterialPage(child: SizedBox())] : pages;
  }

  @override
  Future onRoute(BuildContext context, Object action) async {}
}

extension on RootRouterDelegate {
  List<Page> _createPages(BasePin pin) {
    switch (pin) {
      case Pin():
        return [
          const MaterialPage(
            child: HomeTabbarPage(),
            name: RootRouterDelegatePath.home,
          ),
        ];
      case EmptyPin():
        return [
          const MaterialPage(
            child: PinScreen(),
            name: RootRouterDelegatePath.pin,
          ),
        ];
    }
    // switch (userSession) {
    //   case UnconfiguredSession():
    //     return [
    //       MaterialPage(
    //         child: Router(
    //           routerDelegate: ConfigurationRouterDelegate(),
    //         ),
    //       ),
    //     ];
    //   case UnauthorizedSession():
    //     return [
    //       MaterialPage(
    //         child: PinPage(onRoute: onRoute),
    //         name: RootRouterDelegatePath.pin,
    //       ),
    //     ];
    //   case ValidSession():
    //     return [
    //       const MaterialPage(
    //         child: HomeTabbarPage(),
    //         name: RootRouterDelegatePath.home,
    //       ),
    //     ];
    // }
  }

  StreamSubscription _createSubscriptions() {
    return pinUsecase.pinStream.distinct().asyncMap(
      (e) {
        switch (e) {
          case Pin():
            AppDiModules.bindAuthModules();
          case EmptyPin():
            AppDiModules.dropAuthModules();
        }
        // switch (userSession) {
        //   case UnconfiguredSession():
        //   case UnauthorizedSession():
        //     AppDiModules.dropAuthModules();
        //   case ValidSession():
        //     AppDiModules.bindAuthModules();
        // }

        return e;
      },
    ).listen(
      (_) => updateState(),
    );
  }
}
