import 'package:flutter/material.dart';
import 'notes/presentation/di/sync_di.dart';
import 'package:pwd/common/presentation/di/network_di.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/home/presentation/home_page.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/notes/presentation/di/notes_di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final di = DiStorage.shared;

  NotesDi().bind(di);
  NetworkDiModule().bind(di);
  SyncDi().bind(di);

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
