import 'dart:convert';

import 'package:pwd/common/data/model/app_configuration_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DeveloperSettings {
  static const isProxyEnabled = false;
  static const showRawErrors = true;

  static void applay() {
    _setDeveloperSettings(
      isProxyEnabled: isProxyEnabled,
      showRawErrors: showRawErrors,
    );
  }

  static void _setDeveloperSettings(
      {required bool isProxyEnabled, required bool showRawErrors}) {
    final jsonStr = jsonEncode(
      AppConfigurationData(
        proxyData: isProxyEnabled
            ? const ProxyAppConfigurationData(
                ip: '127.0.0.1',
                port: '8888',
              )
            : null,
        showRawErrors: showRawErrors,
      ).toJson(),
    );

    SharedPreferences.setMockInitialValues({
      'AppConfigurationProvider.AppConfigurationKey': jsonStr,
    });
  }
}
