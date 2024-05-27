import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/presentation/di/app_di_modules.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_page.dart';
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

  var current = const MaterialPage(child: SizedBox());

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (context) => ColoredBox(
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
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

  void _performNavigation(BasePin pin) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      final transitionTheme = CustomPageTransistionsTheme.of(context);
      Navigator.of(context).pushReplacement(
        CustomPageRoute(
          builder: (_) => _getScreen(pin),
          theme: transitionTheme.fade,
          transitionDuration: transitionTheme.fadeDuration,
        ),
      );
    }
  }

  Widget _getScreen(BasePin pin) {
    switch (pin) {
      case Pin():
        return const HomeTabbarPage();
      case EmptyPin():
        return const PinScreen();
    }
  }

  StreamSubscription _createSubscriptions() {
    return pinUsecase.pinStream.distinct().asyncMap(
      (e) {
        _installDI(e);
        return e;
      },
    ).listen(
      (e) => _performNavigation(e),
    );
  }
}
