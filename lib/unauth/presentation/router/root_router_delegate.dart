import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/presentation/di/app_di_modules.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_screen.dart';
import 'package:pwd/theme/custom_page_transistions_theme.dart';
import 'package:pwd/unauth/presentation/pin_page/pin_screen.dart';
import 'package:pwd/unauth/presentation/router/custom_page_route.dart';

final class RootRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final PinUsecase pinUsecase;
  late final StreamSubscription pinSubscription;
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  late final unauthRouterDelegateNavigatorKey = GlobalKey<NavigatorState>();

  late BasePin _pin;

  void setPin(BasePin pin) {
    if (_pin != pin) {
      _pin = pin;
      _installDI(_pin);
      notifyListeners();
    }
  }

  RootRouterDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.pinUsecase,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    _pin = pinUsecase.getPin();
    pinSubscription = _createSubscriptions();
  }

  @override
  void dispose() {
    pinSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transitionTheme = CustomPageTransistionsTheme.of(context).fade;
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_pin is Pin)
          CustomPage(
            key: const ValueKey('HomeTabbarPage'),
            theme: transitionTheme,
            builder: (_) => const HomeTabbarScreen(),
          )
        else
          CustomPage(
            key: const ValueKey('PinScreen'),
            theme: transitionTheme,
            builder: (_) => const PinScreen(),
          )
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (Navigator.of(context).canPop()) {
          return true;
        }

        return false;
      },
    );
  }

  Future onRoute(BuildContext context, Object action) async {}

  @override
  Future<void> setNewRoutePath(configuration) async {}
}

extension on RootRouterDelegate {
  void _installDI(BasePin pin) {
    switch (pin) {
      case Pin():
        AppDiModules.bindAuthModules();
      case EmptyPin():
        AppDiModules.dropAuthModules();
    }
  }

  StreamSubscription _createSubscriptions() =>
      pinUsecase.pinStream.distinct().listen(
            (e) => setPin(e),
          );
}
