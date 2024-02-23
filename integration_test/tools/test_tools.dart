import 'dart:convert';

import 'package:pwd/common/data/model/app_configuration_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class TestTools {
  static void setProxyEnabled(bool isEnabled) {
    final jsonStr = isEnabled
        ? jsonEncode(
            const AppConfigurationData(
              proxyData:
                  ProxyAppConfigurationData(ip: '127.0.0.1', port: '8888'),
              showRawErrors: false,
            ).toJson(),
          )
        : '';

    SharedPreferences.setMockInitialValues({
      'AppConfigurationProvider.AppConfigurationKey': jsonStr,
    });
  }
}
