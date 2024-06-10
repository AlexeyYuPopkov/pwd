import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/configurations_screen.dart';
import 'package:pwd/settings/presentation/remote_configuration/git_configuration_screen/git_configuration_screen.dart';
import 'package:pwd/settings/presentation/remote_configuration/google_drive_configuration_screen/google_drive_configuration_screen.dart';
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
      path: 'google_drive',
      builder: (context, state) {
        final config = state.extra as GoogleDriveConfiguration?;

        return GoogleDriveConfigurationScreen(
          initial: config,
        );
      },
      redirect: redirectToLoginPage,
    ),
    GoRoute(
      path: 'git',
      builder: (context, state) {
        final config = state.extra as GitConfiguration?;

        return GitConfigurationScreen(
          initial: config,
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
                '/settings/configurations/git',
                extra: config,
              );
              break;
            case ConfigurationType.googleDrive:
              final config = configuration is GoogleDriveConfiguration
                  ? configuration
                  : null;

              context.go(
                '/settings/configurations/google_drive',
                extra: config,
              );
              break;
          }
      }
    }
  }
}
