import 'package:flutter/material.dart';
import 'package:di_storage/di_storage.dart';
import 'package:pwd/theme/theme_data.dart';
import 'package:pwd/common/presentation/di/app_di_modules.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'unauth/presentation/router/root_router_delegate.dart';
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

  runApp(MyApp());
}

final class MyApp extends StatelessWidget {
  MyApp({super.key});

  // UserSessionProviderUsecase get userSessionProviderUsecase =>
  //     DiStorage.shared.resolve();

  final rootNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
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
        child: Router(
          routerDelegate: RootRouterDelegate(
            navigatorKey: rootNavigatorKey,
            pinUsecase: DiStorage.shared.resolve(),
          ),
        ),
      ),
    );
  }
}
