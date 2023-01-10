import 'package:flutter/material.dart';

import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/home/presentation/home_page.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/notes/data/datasource/datasource.dart';
import 'package:pwd/notes/data/datasource/datasource_impl.dart';
import 'package:pwd/notes/data/datasource/gateway_impl.dart';

import 'notes/domain/gateway.dart';

void main() {
  final di = DiStorage.shared;

  di.bind<Datasource>(() => DatasourceImpl());

  di.bind<Gateway>(() => GatewayImpl(datasource: di.resolve()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: BlockingLoadingIndicator(
        child: const HomePage(),
      ),
    );
  }
}

// class _RouteInformationProvider extends RouteInformationProvider {
//   @override
//   void addListener(VoidCallback listener) {
//     // TODO: implement addListener
//   }

//   @override
//   void removeListener(VoidCallback listener) {
//     // TODO: implement removeListener
//   }

//   @override
//   // TODO: implement value
//   RouteInformation get value => throw UnimplementedError();

// }
