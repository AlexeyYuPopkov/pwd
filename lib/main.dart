import 'package:flutter/material.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/theme/theme_data.dart';
import 'package:pwd/common/presentation/di/app_di_modules.dart';
import 'package:pwd/home/presentation/home_tabbar_page.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/unauth/presentation/router/unauth_router_delegate.dart';

void main() async {
  // debugRepaintRainbowEnabled = true;
  // debugPaintLayerBordersEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();

  AppDiModules.bindUnauthModules();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  PinUsecase get pinUsecase => DiStorage.shared.resolve();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightThemeData,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      showSemanticsDebugger: false,
      debugShowMaterialGrid: false,
      // checkerboardRasterCacheImages: true,
      home: BlockingLoadingIndicator(
        child: StreamBuilder<BasePin>(
          stream: pinUsecase.pinStream.asyncMap((pin) {
            if (pin is Pin && pinUsecase.isValidPin) {
              AppDiModules.bindAuthModules();
            } else {
              AppDiModules.dropAuthModules();
            }

            return pin;
          }),
          builder: (context, snapshot) {
            final pin = snapshot.data;

            if (pin is Pin && pinUsecase.isValidPin) {
              return const HomeTabbarPage();
            } else {
              return Router(
                routerDelegate: UnauthRouterDelegate(),
              );
            }
          },
        ),
      ),
    );
  }
}
