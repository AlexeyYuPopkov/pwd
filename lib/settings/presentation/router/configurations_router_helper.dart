import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/configurations_screen.dart';
import 'package:pwd/settings/presentation/remote_configuration/git_configuration_screen/git_configuration_screen.dart';
import 'package:pwd/settings/presentation/remote_configuration/google_drive_configuration_screen/google_drive_configuration_screen.dart';
import 'package:pwd/unauth/presentation/router/path_parameters.dart';
import 'package:pwd/unauth/presentation/router/redirect_to_login_page_helper.dart';

final class ConfigurationsRouterHelper with RedirectToLoginPageHelper {
  @override
  final bool Function() isAuthorized;

  ConfigurationsRouterHelper({required this.isAuthorized});

  Widget get initialScreen {
    return ConfigurationsScreen(onRoute: onRoute);
  }

  late final routes = [
    GoRoute(
      path: _GoogleDriveConfigurationScreenPath.shortPath,
      name: _GoogleDriveConfigurationScreenPath.name,
      builder: (context, state) {
        return GoogleDriveConfigurationScreen(
          configId: _GoogleDriveConfigurationScreenPath.getConfigId(state),
        );
      },
      redirect: redirectToLoginPage,
    ),
    GoRoute(
      name: _GitConfigurationScreenScreenPath.name,
      path: _GitConfigurationScreenScreenPath.shortPath,
      builder: (context, state) {
        return GitConfigurationScreen(
          configId: _GitConfigurationScreenScreenPath.getConfigId(state),
        );
      },
      redirect: redirectToLoginPage,
    ),
  ];

  Future onRoute(BuildContext context, Object action) async {
    if (action is ConfigurationScreenRoute) {
      switch (action) {
        case OnPinPageRoute():
          return;
        case OnSetupConfigurationRoute():
          final configuration = action.configuration;
          switch (action.type) {
            case ConfigurationType.git:
              final config =
                  configuration is GitConfiguration ? configuration : null;

              context.go(
                _GitConfigurationScreenScreenPath.namedLocation(
                  context,
                  configId: config?.id,
                ),
              );

              break;
            case ConfigurationType.googleDrive:
              final config = configuration is GoogleDriveConfiguration
                  ? configuration
                  : null;

              context.go(
                _GoogleDriveConfigurationScreenPath.namedLocation(
                  context,
                  configId: config?.id,
                ),
              );
              break;
          }
      }
    }
  }
}

final class _GitConfigurationScreenScreenPath {
  static const name = 'GitConfigurationScreen';
  static const shortPath = 'git/:${PathParameters.configId}';

  static String getConfigId(GoRouterState state) {
    final result = state.pathParameters[PathParameters.configId];
    assert(result != null && result.isNotEmpty);
    return result ?? '';
  }

  static String namedLocation(
    BuildContext context, {
    required String? configId,
  }) =>
      context.namedLocation(
        name,
        pathParameters: {
          if (configId != null) PathParameters.configId: configId,
        },
      );
}

final class _GoogleDriveConfigurationScreenPath {
  static const name = 'GoogleDriveConfigurationScreen';
  static const shortPath = 'google_drive/:${PathParameters.configId}';

  static String getConfigId(GoRouterState state) {
    final result = state.pathParameters[PathParameters.configId];
    assert(result != null && result.isNotEmpty);
    return result ?? '';
  }

  static String namedLocation(
    BuildContext context, {
    required String? configId,
  }) =>
      context.namedLocation(
        name,
        pathParameters: {
          if (configId != null) PathParameters.configId: configId,
        },
      );
}
