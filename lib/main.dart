import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/pin_repository.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/theme/theme_data.dart';
import 'package:pwd/common/presentation/di/app_di_modules.dart';
import 'package:pwd/home/presentation/home_tabbar_page.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/unauth/presentation/router/unauth_router_delegate.dart';

void main() async {
  debugRepaintRainbowEnabled = false;

  WidgetsFlutterBinding.ensureInitialized();

  AppDiModules.bindUnauthModules();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  PinRepository get pinRepository => DiStorage.shared.resolve();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightThemeData,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      showSemanticsDebugger: false,
      debugShowMaterialGrid: false,
      home: BlockingLoadingIndicator(
        child: StreamBuilder<BasePin>(
          stream: pinRepository.pinStream,
          builder: (context, snapshot) {
            final pin = snapshot.data;

            if (pin is Pin && pinRepository.isValidPin) {
              AppDiModules.dropAuthModules();
              return const HomeTabbarPage();
            } else {
              AppDiModules.bindAuthModules();
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
