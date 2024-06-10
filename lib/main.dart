import 'dart:async';

import 'package:flutter/material.dart';
import 'package:di_storage/di_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/home/presentation/home_tabbar/home_router_helper.dart';
import 'package:pwd/theme/theme_data.dart';
import 'package:pwd/common/presentation/di/app_di_modules.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'unauth/presentation/router/root_router_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // debugRepaintRainbowEnabled = true;
  // debugPaintLayerBordersEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();

// TODO: refactor
  AppDiModules.bindUnauthModules();

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // AppLifecycleState

    return MaterialApp(
      color: Colors.white,
      theme: lightThemeData,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      showSemanticsDebugger: false,
      // debugShowMaterialGrid: false,
      // checkerboardRasterCacheImages: true,
      home: BlockingLoadingIndicator(
        child: const RouterWidget(),
      ),
    );
  }
}

final class RouterWidget extends StatefulWidget {
  const RouterWidget({super.key});

  @override
  State<RouterWidget> createState() => _RouterWidgetState();
}

final class _RouterWidgetState extends State<RouterWidget> {
  late final PinUsecase pinUsecase = DiStorage.shared.resolve();
  late final StreamSubscription pinSubscription;
  late final rootRouterHelper = RootRouterHelper(
    isAuthorized: () => pinUsecase.getPin() is Pin,
  );

  @override
  void initState() {
    super.initState();
    pinSubscription = pinUsecase.pinStream.distinct().listen((e) {
      _installDI(e);
      _performNavigation(e);
    });
  }

  @override
  void dispose() {
    pinSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Router.withConfig(config: rootRouterHelper.router);
  }

  void _installDI(BasePin pin) {
    switch (pin) {
      case Pin():
        AppDiModules.bindAuthModules();
      case EmptyPin():
        AppDiModules.dropAuthModules();
    }
  }

  void _performNavigation(BasePin pin) {
    final path = pin is EmptyPin
        ? RootRouterUnauthPath.shortPath
        : HomeRouterUndefinedTabPath.shortPath;
    RootRouterHelper.navigatorKey.currentContext?.go(path);
  }
}
