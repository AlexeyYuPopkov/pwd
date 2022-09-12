import 'package:flutter/material.dart';
import 'package:pwd/view/router/main_router_delegate.dart';
import 'package:pwd/view/router/main_router_state.dart';
import 'package:pwd/view/router/common/page_information_parser.dart';

import 'common/di/di_scope.dart';
import 'view/di/di.dart';

void main() {
  final scope = DiScope.single();

  scope.installModules(
    [
      MainModule(),
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _routerDelegate = MainRouterDelegate(
    state: MainRouterState(),
    initialPathComponents: [''],
    parentContextProvider: () => context,
  );

  late final _routeInformationParser = PageInformationParser(
    delegate: _routerDelegate,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Router(
        routerDelegate: _routerDelegate,
        routeInformationParser: _routeInformationParser,
      ),
    );
  }
}
