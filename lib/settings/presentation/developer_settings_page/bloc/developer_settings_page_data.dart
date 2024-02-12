import 'package:equatable/equatable.dart';

import 'package:pwd/common/domain/model/app_configuration.dart';
import 'package:pwd/common/support/optional_box.dart';

final class DeveloperSettingsPageData extends Equatable {
  final OptionalBox<ProxyAppConfiguration> proxy;
  final bool showRawErrors;
  final OptionalBox<AppConfiguration> initialAppConfiguration;

  const DeveloperSettingsPageData._({
    required this.proxy,
    required this.showRawErrors,
    required this.initialAppConfiguration,
  });

  factory DeveloperSettingsPageData.initial() {
    final defaultConfiguration = AppConfiguration.defaultConfiguration();
    return DeveloperSettingsPageData._(
      proxy: OptionalBox(defaultConfiguration.proxyData),
      showRawErrors: defaultConfiguration.showRawErrors,
      initialAppConfiguration: const OptionalBox(null),
    );
  }

  factory DeveloperSettingsPageData.withAppConfiguration(
    AppConfiguration configuration,
  ) {
    return DeveloperSettingsPageData._(
      proxy: OptionalBox(configuration.proxyData),
      showRawErrors: configuration.showRawErrors,
      initialAppConfiguration: OptionalBox(configuration),
    );
  }

  @override
  List<Object?> get props => [
        proxy.data?.ip,
        proxy.data?.port,
        showRawErrors,
      ];

  DeveloperSettingsPageData copyWith({
    OptionalBox<ProxyAppConfiguration>? proxy,
    bool? showRawErrors,
  }) {
    return DeveloperSettingsPageData._(
      proxy: proxy ?? this.proxy,
      showRawErrors: showRawErrors ?? this.showRawErrors,
      initialAppConfiguration: initialAppConfiguration,
    );
  }

  AppConfiguration get appConfiguration => AppConfiguration(
        proxyData: proxy.data,
        showRawErrors: showRawErrors,
      );
}
