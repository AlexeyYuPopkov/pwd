// import 'package:flutter/widgets.dart';
// import 'package:go_router/go_router.dart';
// import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
// import 'package:pwd/home/presentation/configuration_undefined_screen/configuration_undefined_screen.dart';
// import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/configurations_screen.dart';
// import 'package:pwd/unauth/presentation/router/redirect_to_login_page_helper.dart';

// final class ConfigurationUndefinedTabRouterHelper
//     with RedirectToLoginPageHelper {
//   final String initialPath;
//   @override
//   final bool Function() isAuthorized;

//   ConfigurationUndefinedTabRouterHelper({
//     required this.initialPath,
//     required this.isAuthorized,
//   });

//   Widget getInitialScreen() {
//     return ConfigurationUndefinedScreen(onRoute: onRoute);
//   }

//   Future onRoute(BuildContext context, Object action) async {
//     if (action is ConfigurationUndefinedScreensRoute) {
//       switch (action) {
//         case ToSettingsRoute():
//           context.go('/settings/configurations');
//           break;
//       }
//     }
//     // else if (action is ConfigurationScreenRoute) {
//     //   switch (action) {
//     //     case OnPinPageRoute():
//     //       return;
//     //     case OnSetupConfigurationRoute():
//     //       final configuration = action.configuration;
//     //       switch (action.type) {
//     //         case ConfigurationType.git:
//     //           // final git =
//     //           //     configuration is GitConfiguration ? configuration : null;
//     //           // return context.navigator.push(
//     //           //   MaterialPageRoute(
//     //           //     builder: (_) => GitConfigurationScreen(
//     //           //       initial: git,
//     //           //     ),
//     //           //   ),
//     //           // );
//     //           break;
//     //         case ConfigurationType.googleDrive:
//     //           // final googleDrive = configuration is GoogleDriveConfiguration
//     //           //     ? configuration
//     //           //     : null;
//     //           // return context.navigator.push(
//     //           //   MaterialPageRoute(
//     //           //     builder: (_) => GoogleDriveConfigurationScreen(
//     //           //       initial: googleDrive,
//     //           //     ),
//     //           //   ),
//     //           // );

//     //           break;
//     //       }
//     //   }
//     // }
//   }
// }
