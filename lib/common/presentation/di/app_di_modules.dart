import 'package:di_storage/di_storage.dart';
import 'package:pwd/common/presentation/di/network_di.dart';
import 'package:pwd/notes/presentation/di/git_relatedl_di.dart';
import 'package:pwd/notes/presentation/di/google_and_realm_di.dart';
import 'package:pwd/settings/presentation/di/settings_di.dart';

import 'unauth_di_module.dart';

final class AppDiModules {
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

    NetworkDiModule().bind(di);
    GoogleAndRealmDi().bind(di);
    GitRelatedlDi().bind(di);

    SettingsDi().bind(di);
  }

  /// Drop auth DI modules
  static void dropAuthModules() {
    final di = DiStorage.shared;

    di.removeScope<NetworkDiModule>();
    di.removeScope<GoogleAndRealmDi>();
    di.removeScope<GitRelatedlDi>();
    di.removeScope<SettingsDi>();
  }
}
