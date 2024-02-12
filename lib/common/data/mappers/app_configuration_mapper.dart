import 'package:pwd/common/data/model/app_configuration_data.dart';
import 'package:pwd/common/domain/model/app_configuration.dart';

final class AppConfigurationMapper {
  static AppConfiguration toDomain(AppConfigurationData src) {
    final proxyData = src.proxyData;
    return AppConfiguration(
      proxyData: proxyData == null
          ? null
          : ProxyAppConfiguration(
              ip: proxyData.ip,
              port: proxyData.port,
            ),
      showRawErrors: src.showRawErrors,
    );
  }

  static AppConfigurationData toData(AppConfiguration src) {
    final proxyData = src.proxyData;
    return AppConfigurationData(
      proxyData: proxyData == null
          ? null
          : ProxyAppConfigurationData(
              ip: proxyData.ip,
              port: proxyData.port,
            ),
      showRawErrors: src.showRawErrors,
    );
  }
}
