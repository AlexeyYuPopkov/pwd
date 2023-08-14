import 'package:pwd/common/presentation/di/network_di.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/presentation/di/notes_di.dart';
import 'package:pwd/notes/presentation/di/sync_di.dart';

import 'unauth_di_module.dart';

class AppDiModules {
  /// Bind unauth DI modules
  static void bindUnauthModules() {
    final di = DiStorage.shared;

    di.removeScope<UnauthDiModule>();
    UnauthDiModule().bind(di);
  }

  /// Bind auth DI modules
  static void bindAuthModules() {
    final di = DiStorage.shared;

    dropAuthModules();
    NotesDi().bind(di);
    NetworkDiModule().bind(di);
    SyncDi().bind(di);
  }

  /// Drop auth DI modules
  static void dropAuthModules() {
    final di = DiStorage.shared;

    di.removeScope<NotesDi>();
    di.removeScope<NetworkDiModule>();
    di.removeScope<SyncDi>();
  }
}
