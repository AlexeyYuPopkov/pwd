import 'package:flutter/material.dart';
import 'package:pwd/common/domain/usecases/user_session_provider_usecase.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/theme/theme_data.dart';
import 'package:pwd/common/presentation/di/app_di_modules.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'unauth/presentation/router/root_router_delegate.dart';

void main() async {
  // debugRepaintRainbowEnabled = true;
  // debugPaintLayerBordersEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();

  AppDiModules.bindUnauthModules();

  runApp(MyApp());
}

final class MyApp extends StatelessWidget {
  MyApp({super.key});

  UserSessionProviderUsecase get userSessionProviderUsecase =>
      DiStorage.shared.resolve();

  final rootNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            userSessionProviderUsecase: userSessionProviderUsecase,
          ),
        ),
      ),
    );
  }
}
